module CompactFlags
  
  
  def compact_flags(mapping)
    name = mapping.keys.first
    flags = mapping[name]
    raise "No flags defined" if flags.blank?
    raise "Too many flags" if flags.size > 31
    
    @@flags ||={}
    i=0

    flags.each do |flag|
      @@flags[flag] = 1 << i
      i += 1 
      
      define_method "#{flag}" do
        return (@@flags[flag] & self.send(name)) > 0
      end
      
      alias_method "#{flag}?", "#{flag}"
      
      define_method "#{flag}=" do |val|
        self.send("#{name}=", (val ? 
            self.send(name) | @@flags[flag] :
            self.send(name) ^ @@flags[flag]))
      end
    end
  
  end
end
