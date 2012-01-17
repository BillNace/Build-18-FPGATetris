class bmp
  byte letA = 65;
  byte enter = 13;
  byte space = 32;

  task run();
    File = $fopen("samp.txt");
    if(!File) $display("ERROR");
    else begin
      $sformat(FILE, 
    end

  endtask


endclass

module tb();


endmodule
