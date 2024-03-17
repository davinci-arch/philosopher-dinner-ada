package sempahorescounters is
type counters is array(1 .. 5) of Integer;
   protected SemaphoreCounter is
      procedure generateCounters;
      procedure decrementCounter(idx: Integer);
      procedure incrementCounter(idx: Integer);
      function availablePermission(idx: Integer) return Integer;
      
   private
      
      counter: counters;
   end SemaphoreCounter;
end sempahorescounters;
