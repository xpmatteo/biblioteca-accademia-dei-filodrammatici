module RomanNumerals
  @@centuries = { 
    10 => "X", 
    11 => "XI",
    12 => "XII",
    13 => "XIII",
    14 => "XIV",
    15 => "XV",
    16 => "XVI",
    17 => "XVII",
    18 => "XVIII",
    19 => "XIX",
    20 => "XX",
    21 => "XXI",
  }

  def RomanNumerals.decimal_to_roman(century)
    @@centuries[century] || century
  end
  
  def RomanNumerals.roman_to_decimal(century)
    @@centuries.each do |decimal, roman|
      return decimal if roman == century
    end
    nil
  end  
end