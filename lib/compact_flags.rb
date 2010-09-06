module CompactFlags
  
  MAX_FLAGS_MAPPING = 0xFFFFFFFF
  MAX_FLAGS_COUNT = 31
  
  def compact_flags(mapping)
    store_column = mapping.keys.first
    flags = mapping[store_column]
    raise "No flags defined" if flags.blank?
    raise "Too many flags" if flags.size > MAX_FLAGS_COUNT
    
    @@flags ||={}
    @@store_columns ||={}
    i=0

    flags.each do |flag|
      @@flags[flag] = 1 << i
      @@store_columns[flag] = store_column
      i += 1 

      # Define instance getter 
      define_method "#{flag}" do
        return (@@flags[flag] & self.send(store_column)) > 0
      end

      alias_method "#{flag}?", "#{flag}"
      
      # Define instance setter
      define_method "#{flag}=" do |val|
        self.send("#{store_column}=", (val ? 
            self.send(store_column) | @@flags[flag] :
            self.send(store_column) & (MAX_FLAGS_MAPPING ^ @@flags[flag]) ))
      end
      
      # named scopes to be used in conditions
      named_scope "#{flag}".pluralize.to_sym, :conditions=>"(#{@@store_columns[flag]} & #{@@flags[flag]}) > 0"
      named_scope "not_#{flag}".pluralize.to_sym, :conditions=>"(#{@@store_columns[flag]} & #{@@flags[flag]}) = 0"
    end

    # Defining a generic class method to get the bit number of each flag. if it was 
    # desired to be used manually by the programmer. Not recommended to be used though
    class << self
      @@flags.each do |key, value|
        define_method "#{key}_value" do
          return value
        end
      end
    end
  
  end
end
