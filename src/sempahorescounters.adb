package body sempahorescounters is

   protected body SemaphoreCounter is
      procedure generateCounters is
      begin
         for i in counters'Range loop
            counter(i) := 1;
         end loop;
      end generateCounters;
      procedure decrementCounter(idx: Integer) is
      begin
         counter(idx) := counter(idx) - 1;
      end decrementCounter;
      procedure incrementCounter(idx: Integer) is 
      begin
         counter(idx) := counter(idx) + 1;
      end incrementCounter;
      function availablePermission(idx: Integer) return Integer is
      begin
         return counter(idx);
      end availablePermission;
   end SemaphoreCounter;

end sempahorescounters;
