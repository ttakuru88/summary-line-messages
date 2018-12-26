class Summary < ApplicationRecord
  has_many :users, dependent: :delete_all

  serialize :pickup_words, Array

  before_create :generate_uuid

  DAY_FORMAT = /^\d\d\d\d\/\d\d\/\d\d/.freeze
  TIME_FORMAT = /^\d\d:\d\d/.freeze

  def import_from!(uploaded_file)
    new_users = {}
    current_date = nil
    File.open(uploaded_file.path, 'r').read.split("\n").each do |line|
      if DAY_FORMAT === line
        current_date = Time.parse(line)
        self.start_at ||= current_date
        self.end_at = current_date
        next
      end
      next unless TIME_FORMAT === line

      date, name, text = line.split("\t").map(&:chomp)
      next unless text

      new_users[name] ||= {start_at: current_date, messages_count: 0, kusas_count: 0, photos_count: 0, stamps_count: 0, message_count_per_hour: Array.new(24) { 0 }}

      new_users[name][:messages_count] += 1
      new_users[name][:stamps_count] += 1 if text == '[スタンプ]'
      new_users[name][:photos_count] += 1 if text == '[写真]'

      kusa = text.match(/w+$/)
      new_users[name][:kusas_count] += kusa[0].size if kusa

      h, m = date.split(':').map(&:to_i)
      new_users[name][:message_count_per_hour][h] += 1
      new_users[name][:end_at] = current_date
    end

    importable_new_users = new_users.map do |name, data|
      data.merge({summary_id: id, name: name, message_count_per_hour: data[:message_count_per_hour].join(',')})
    end
    User.import(importable_new_users)

    save!
  end

  def messages_count
    users.sum(&:messages_count)
  end

  def kusas_count
    users.sum(&:kusas_count)
  end

  def photos_count
    users.sum(&:photos_count)
  end

  def stamps_count
    users.sum(&:stamps_count)
  end

  def message_count_per_hour
    @message_count_per_hour ||= 24.times.map { |h| users.sum { |u| u.message_count_per_hour[h] } }
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end
end
