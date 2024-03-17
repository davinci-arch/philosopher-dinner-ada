with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Semaphores; use GNAT.Semaphores;
with sempahorescounters; use sempahorescounters;

procedure Main is
   task type Phylosopher is
      entry Start(Id : Integer);
   end Phylosopher;

   Forks : array (1..5) of Counting_Semaphore(1, Default_Ceiling);
   permissionDenied: Counting_Semaphore(1, Default_Ceiling);
   waitForFork: Counting_Semaphore(0, Default_Ceiling);

   task body Phylosopher is
      Id : Integer;
      Id_Left_Fork, Id_Right_Fork : Integer;
   begin
      accept Start (Id : in Integer) do
         Phylosopher.Id := Id;
      end Start;
      Id_Left_Fork := Id;
      Id_Right_Fork := Id rem 5 + 1;



      for I in 1..10 loop

         Put_Line("Phylosopher " & Id'Img & " thinking " & I'Img & " time");
         while (true) loop
            permissionDenied.Seize;
            if (SemaphoreCounter.availablePermission(Id_Left_Fork) = 1
                and SemaphoreCounter.availablePermission(Id_Right_Fork) = 1) then

               Forks(Id_Left_Fork).Seize;
               SemaphoreCounter.decrementCounter(Id_Left_Fork);
               Put_Line("Phylosopher " & Id'Img & " took left fork");

               Forks(Id_Right_Fork).Seize;
               SemaphoreCounter.decrementCounter(Id_Right_Fork);
               Put_Line("Phylosopher " & Id'Img & " took right fork");
               exit;
            else
               permissionDenied.Release;
               waitForFork.Seize;
            end if;
         end loop;
         permissionDenied.Release;
         Put_Line("Phylosopher " & Id'Img & " eating" & I'Img & " time");

         Forks(Id_Right_Fork).Release;
         SemaphoreCounter.incrementCounter(Id_Right_Fork);
         Put_Line("Phylosopher " & Id'Img & " put right fork");

         Forks(Id_Left_Fork).Release;
         SemaphoreCounter.incrementCounter(Id_Left_Fork);
         Put_Line("Phylosopher " & Id'Img & " put left fork");
         waitForFork.Release;
      end loop;
   end Phylosopher;

   Phylosophers : array (1..5) of Phylosopher;
Begin
   SemaphoreCounter.generateCounters;
   for I in Phylosophers'Range loop
      Phylosophers(I).Start(I);
   end loop;
end Main;
