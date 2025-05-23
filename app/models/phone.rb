class Phone
  attr_reader :input, :number

  def initialize(input = nil)
    @input = input
    @number = input.to_s.gsub(/\D/, '')
    @number[0] = '7' if valid? && @number[0] == '8'
    @number = @number.presence
  end

  def to_s
    "+#{@number[0]} #{@number[1..3]} #{@number[4..6]}-#{@number[7..8]}-#{@number[9..10]}"
  end

  def to_account
    (@number[1..10]).to_s
  end

  def to_sms
    "+#{@number}"
  end

  def valid?
    return false unless @number
    return false unless %w(7 8).include?(@number[0]) && @number.length == 11

    true
  end
end
