helpers do
  def bytes_to_gigabytes bytes
    "%.2f" % (bytes.to_f / 1_073_741_824.to_f)
  end
end