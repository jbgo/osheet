module Osheet::StyledElement
  def style_class(value); set_ivar(:style_class, verify_style_class(value)); end

  private

  def verify_style_class(style_class)
    if !style_class.kind_of?(::String) || invalid_style_class?(style_class)
      raise ArgumentError, "invalid style_class: '#{style_class}', cannot contain '.' or '>'"
    else
      style_class
    end
  end

  def invalid_style_class?(style_class)
    style_class =~ /\.+/ ||
    style_class =~ />+/
  end
end
