module Valid
  def valid?
    validate!
    true
  rescue ValidationError
    false
  end
end
