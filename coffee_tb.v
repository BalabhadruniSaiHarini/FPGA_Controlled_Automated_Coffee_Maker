module coffee_maker_tb();
    reg clk = 0;
    reg rst = 1;
    reg ir_sensor = 1;                   
    reg [1:0] flavour_select = 2'b11;     
    reg [1:0] sugar_select = 2'b01;      
    reg [7:0] temp_value = 8'd20;         

    wire cup, whole_milk, water, coffee_powder, stirrer, sugar, heater;
    wire milk_dispenser, expresso_dispenser, cappuccino_dispenser;
    wire latte_dispenser, mocha_dispenser;
    wire done, led_temp, buzzer;
    wire [3:0] led_flavor;

    coffee_maker uut (
        .clk(clk),
        .rst(rst),
        .ir_sensor(ir_sensor),
        .flavour_select(flavour_select),
        .sugar_select(sugar_select),
        .temp_value(temp_value),
        .cup(cup),
        .whole_milk(whole_milk),
        .water(water),
        .coffee_powder(coffee_powder),
        .sugar(sugar),
        .stirrer(stirrer),
        .heater(heater),
        .milk_dispenser(milk_dispenser),
        .expresso_dispenser(expresso_dispenser),
        .cappuccino_dispenser(cappuccino_dispenser),
        .latte_dispenser(latte_dispenser),
        .mocha_dispenser(mocha_dispenser),
        .done(done),
        .led_temp(led_temp),
        .led_flavor(led_flavor),
        .buzzer(buzzer)
    );

    always #5 clk = ~clk;

    initial begin
        $display("==== COFFEE MAKER SYSTEM SIMULATION START ====");
        $monitor("Time: %0t | State: %0d | Temp: %d | Heater: %b | Whole Milk: %b | Stirrer: %b | Espresso: %b | Cappuccino: %b | Latte: %b | Mocha: %b | Done: %b | Temp: %b | Flavor_LED: %b | Buzzer: %b",
                 $time, uut.state, temp_value, heater, whole_milk, stirrer,
                 expresso_dispenser, cappuccino_dispenser, latte_dispenser, mocha_dispenser,
                 done, led_temp, led_flavor, buzzer);

        ir_sensor = 1;

        #10 rst = 0;  
        repeat (100) begin
            #10;
            if (uut.heater && temp_value < uut.TEMP_TARGET)
                temp_value = temp_value + 1;
            else if (!uut.heater && temp_value > 8'd80)
                temp_value = temp_value - 1;
        end

        #200; 
        $display("==== COFFEE MAKER SYSTEM SIMULATION COMPLETE ====");
        $finish;
    end
endmodule