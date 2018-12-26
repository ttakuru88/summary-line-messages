class Summary < ApplicationRecord
  has_many :users, dependent: :delete_all

  # serialize :pickup_words, Array

  before_create :generate_uuid

  DAY_FORMAT = /^\d\d\d\d\/\d\d\/\d\d/.freeze
  TIME_FORMAT = /^\d\d:\d\d/.freeze

  def import_from!(uploaded_file, pickup_words:)
    self.pickup_words = pickup_words

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

      new_users[name] ||= {
        start_at: current_date,
        messages_count: 0,
        kusas_count: 0,
        photos_count: 0,
        stamps_count: 0,
        messages_count_per_hour: Array.new(24) { 0 },
        count_per_pickup_word: Hash.new { 0 },
      }

      new_users[name][:messages_count] += 1
      new_users[name][:stamps_count] += 1 if text == '[スタンプ]'
      new_users[name][:photos_count] += 1 if text == '[写真]'
      pickup_words.each do |word|
        new_users[name][:count_per_pickup_word][word] += text.count(word)
      end

      kusa = text.match(/w+$/)
      new_users[name][:kusas_count] += kusa[0].size if kusa

      h, m = date.split(':').map(&:to_i)
      new_users[name][:messages_count_per_hour][h] += 1
      new_users[name][:end_at] = current_date
    end

    new_users.each do |name, data|
      users.create!(data.merge({
        summary_id: id,
        name: name,
        messages_count_per_hour: data[:messages_count_per_hour],
        count_per_pickup_word: data[:count_per_pickup_word],
      }))
    end

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

  def messages_count_per_hour
    @messages_count_per_hour ||= 24.times.map { |h| users.sum { |u| u.messages_count_per_hour[h] } }
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end
end
