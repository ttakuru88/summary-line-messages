# require 'file'

DATE_FORMAT = /^\d\d:\d\d/.freeze

say_count = {}
sum = {
  count: 0,
  kusa: 0,
  stamps: 0,
  photos: 0,
  hours: Array.new(24) { 0 },
}

File.open('./wcat_talk.txt') do |f|
  f.each_line do |line|
    next unless DATE_FORMAT === line

    date, name, text = line.split("\t").map(&:chomp)
    next unless text

    unless say_count[name]
      say_count[name] = {name: name, count: 0, kusa: 0, photos: 0, stamps: 0, hours: Array.new(24) { 0 }}
    end
    say_count[name][:count] += 1
    sum[:count] += 1

    if text == '[スタンプ]'
      say_count[name][:stamps] += 1
      sum[:stamps] += 1
    end

    if text == '[写真]'
      say_count[name][:photos] += 1
      sum[:photos] += 1
    end

    kusa = text.match(/w+$/)
    if kusa
      say_count[name][:kusa] += kusa[0].size
      sum[:kusa] += kusa[0].size
    end

    h, m = date.split(':').map(&:to_i)
    say_count[name][:hours][h] += 1
    sum[:hours][h] += 1
  end
end

sorted_data = say_count.map { |name, data| data }.sort_by { |d| d[:count] }.reverse

def puts_each_hours(sum, hours)
  max_ratio = 0
  hours.each do |count|
    ratio = count.to_f / sum
    max_ratio = ratio if ratio > max_ratio
  end
  hours.each_with_index do |count, h|
    w = (count.to_f / sum / max_ratio * 20).to_i
    puts "#{'%2d' % h}時#{'%4d' % count} #{'-' * w}"
  end
end

puts "ビッグデータ"
puts
puts "発言数 #{sum[:count]}"
puts "スタンプ #{sum[:stamps]}"
puts "写真 #{sum[:photos]}"
puts "草 #{sum[:kusa]}"
puts
puts "時間帯別"
puts_each_hours(sum[:count], sum[:hours])
puts
puts "個人別"
puts
sorted_data.each do |data|
  puts "#{data[:name]} さん"
  puts "発言数 #{data[:count]}"
  puts "スタンプ #{data[:stamps]}"
  puts "写真 #{data[:photos]}"
  puts "草 #{data[:kusa]}"
  puts_each_hours(data[:count], data[:hours])
  # p data
  puts
end
