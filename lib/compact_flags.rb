module CompactFlags
  
  def compact_flags(*flags)
    raise "Too many flags" if flags.size > 31
    
    @@flags||={}
    i=0
    flags.each do |flag|
      @@flags[flag] = 1 << i
      i += 1 
      
      define_method "#{flag}" do
        return (@@flags[flag] & self.compact_flags_store) > 0
      end
      
      alias_method "#{flag}?", "#{flag}"
      
      define_method "#{flag}=" do |val|
        self.compact_flags_store = val ? 
                    self.compact_flags_store | @@flags[flag] :
                    self.compact_flags_store ^ @@flags[flag]
      end
    end
  end
  
end
