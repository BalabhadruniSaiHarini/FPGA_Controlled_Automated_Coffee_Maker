module coffee_maker (
    input clk,
    input rst,
    input ir_sensor,
    input [1:0] flavour_select,
    input [1:0] sugar_select,
    input [7:0] temp_value,

    output reg cup,
    output reg whole_milk,
    output reg water,
    output reg coffee_powder,
    output reg sugar,
    output reg stirrer,
    output reg heater,
    output reg milk_dispenser,
    output reg expresso_dispenser,
    output reg cappuccino_dispenser,
    output reg latte_dispenser,
    output reg mocha_dispenser,
    output reg done,
    output reg led_temp,
    output reg [3:0] led_flavor,
    output reg buzzer
);

    parameter IDLE = 4'b0000;
    parameter WAIT_IR = 4'b0001;
    parameter ADD_WATER = 4'b0010;
    parameter ADD_COFFEE = 4'b0011;
    parameter ADD_SUGAR = 4'b0100;
    parameter STIR_INITIAL = 4'b0101;
    parameter HEAT_MILK = 4'b0110;
    parameter DISPENSE_MILK = 4'b0111;
    parameter WAIT_SYRUP = 4'b1000;
    parameter DISPENSE_SYRUP = 4'b1001;
    parameter DONE_STATE = 4'b1010;
    parameter TEMP_TARGET = 8'd60;
    parameter WAIT_SYRUP_DELAY = 2;
    parameter DISPENSE_SYRUP_DELAY = 2;
    parameter SUGAR_FULL_DELAY = 2;
    parameter SUGAR_LESS_DELAY = 1;
    parameter STIR_INITIAL_DELAY = 1;

 
    parameter SUGAR_NONE = 2'b00;
    parameter SUGAR_FULL = 2'b01;
    parameter SUGAR_LESS = 2'b10;

    reg [3:0] state;
    reg [7:0] delay_counter;
    reg [7:0] sugar_delay_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            {cup, whole_milk, water, coffee_powder, stirrer, sugar, heater,
             milk_dispenser, expresso_dispenser, cappuccino_dispenser,
             latte_dispenser, mocha_dispenser, done, buzzer} <= 0;
            led_temp <= 0;
            led_flavor <= 4'b0000;
            delay_counter <= 0;
            sugar_delay_counter <= 0;
            state <= IDLE;
        end else begin
            cup <= 1; 

            whole_milk <= 0;
            water <= 0;
            coffee_powder <= 0;
            stirrer <= 0;
            sugar <= 0;
            heater <= 0;
            milk_dispenser <= 0;
            expresso_dispenser <= 0;
            cappuccino_dispenser <= 0;
            latte_dispenser <= 0;
            mocha_dispenser <= 0;
            done <= 0;
            led_temp <= 0;
            buzzer <= 0;

            case (state)
                IDLE: begin
                    $display("Time: %0t | State: IDLE -> Waiting for cup.", $time);
                    state <= WAIT_IR;
                end

                WAIT_IR: begin
                       cup <= ir_sensor; 
                       if (ir_sensor) begin
                       case (flavour_select)
                            2'b00: led_flavor <= 4'b0001;
                            2'b01: led_flavor <= 4'b0010;
                            2'b10: led_flavor <= 4'b0100;
                             2'b11: led_flavor <= 4'b1000;
                             default: led_flavor <= 4'b0001;
                       endcase
                         $display("Time: %0t | State: WAIT_IR -> Cup detected (ir_sensor = 1).", $time);
                        state <= ADD_WATER;
                 end else begin
                      $display("Time: %0t | State: WAIT_IR -> Waiting for cup (ir_sensor = 0).", $time);
                  end
             end

                ADD_WATER: begin
                    water <= 1;
                    coffee_powder <= 1;
                    $display("Time: %0t | State: ADD_WATER -> Dispensing water and powder.", $time);
                    delay_counter <= 0;
                    sugar_delay_counter <= 0;
                    state <= ADD_COFFEE;
                end

                ADD_COFFEE: begin
                    case (sugar_select)
                        SUGAR_FULL: begin
                            sugar <= 1;
                            sugar_delay_counter <= 0;
                            $display("Time: %0t | ADD_COFFEE -> Full sugar.", $time);
                            state <= ADD_SUGAR;
                        end
                        SUGAR_LESS: begin
                            sugar <= 1;
                            sugar_delay_counter <= 0;
                            $display("Time: %0t | ADD_COFFEE -> Less sugar.", $time);
                            state <= ADD_SUGAR;
                        end
                        SUGAR_NONE: begin
                            $display("Time: %0t | ADD_COFFEE -> No sugar.", $time);
                            state <= STIR_INITIAL;
                        end
                        default: begin
                            $display("Time: %0t | Invalid sugar selection.", $time);
                            state <= STIR_INITIAL;
                        end
                    endcase
                end

                ADD_SUGAR: begin
                    sugar_delay_counter <= sugar_delay_counter + 1;
                    if ((sugar_select == SUGAR_FULL && sugar_delay_counter >= SUGAR_FULL_DELAY) ||
                        (sugar_select == SUGAR_LESS && sugar_delay_counter >= SUGAR_LESS_DELAY)) begin
                        sugar <= 0;
                        delay_counter <= 0;
                        state <= STIR_INITIAL;
                    end else begin
                        sugar <= 1;
                    end
                end

                STIR_INITIAL: begin
                    stirrer <= 1;
                    delay_counter <= delay_counter + 1;
                    if (delay_counter >= STIR_INITIAL_DELAY) begin
                        delay_counter <= 0;
                        state <= HEAT_MILK;
                    end
                end

                HEAT_MILK: begin
                    heater <= 1;
                    whole_milk <= 1;
                    stirrer <= 1;
                    if (temp_value >= TEMP_TARGET) begin
                        heater <= 0;
                        whole_milk <= 0;
                        led_temp <= 1;
                        milk_dispenser <= 1;
                        delay_counter <= 0;
                        state <= DISPENSE_MILK;
                    end
                end

                DISPENSE_MILK: begin
                    milk_dispenser <= 0;
                    stirrer <= 0;
                    state <= WAIT_SYRUP;
                end

                WAIT_SYRUP: begin
                    delay_counter <= delay_counter + 1;
                    if (delay_counter >= WAIT_SYRUP_DELAY) begin
                        expresso_dispenser <= 0; 
                             cappuccino_dispenser <= 0; 
                            latte_dispenser <= 0; 
                             mocha_dispenser <= 0; 
                            expresso_dispenser <= 0; 
                       case (flavour_select)
                             2'b00: expresso_dispenser <= 1;
                             2'b01: cappuccino_dispenser <= 1;
                              2'b10: latte_dispenser <= 1;
                              2'b11: mocha_dispenser <= 1;
                             default: expresso_dispenser <= 1;
                       endcase
                        delay_counter <= 0;
                        state <= DISPENSE_SYRUP;
                    end
                end

                DISPENSE_SYRUP: begin
                    delay_counter <= delay_counter + 1;
                    if (delay_counter >= DISPENSE_SYRUP_DELAY) begin
                        expresso_dispenser <= 0;
                        cappuccino_dispenser <= 0;
                        latte_dispenser <= 0;
                        mocha_dispenser <= 0;
                        done <= 1;
                        buzzer <= 1;
                        state <= DONE_STATE;
                    end
                end

                DONE_STATE: begin
                    buzzer <= 0;
                    done <= 1;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule