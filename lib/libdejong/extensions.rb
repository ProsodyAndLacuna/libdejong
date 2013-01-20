class Float
  def map_space(start1, stop1, start2, stop2)
    start2 + (stop2 - start2) * ((self - start1) / (stop1 - start1))
  end
end
