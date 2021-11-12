module tri_state_mux(out, select, in0, in1, in2, in3, in4, in5, in6, in7,
                          in8, in9, in10, in11, in12, in13, in14, in15,
                          in16, in17, in18, in19, in20, in21, in22, in23,
                          in24, in25, in26, in27, in28, in29, in30, in31);
    input [4:0] select;
    input [31:0] in0, in1, in2, in3, in4, in5, in6, in7,
                                            in8, in9, in10, in11, in12, in13, in14, in15,
                                            in16, in17, in18, in19, in20, in21, in22, in23,
                                            in24, in25, in26, in27, in28, in29, in30, in31;

    output [31:0] out;

    wire [31:0] decoder_out;

    decoder32 decoder(.out(decoder_out), .select(select), .enable(1'b1));

    my_tri tri_0(.out(out), .in(in0), .oe(decoder_out[0]));
    my_tri tri_1(.out(out), .in(in1), .oe(decoder_out[1]));
    my_tri tri_2(.out(out), .in(in2), .oe(decoder_out[2]));
    my_tri tri_3(.out(out), .in(in3), .oe(decoder_out[3]));
    my_tri tri_4(.out(out), .in(in4), .oe(decoder_out[4]));
    my_tri tri_5(.out(out), .in(in5), .oe(decoder_out[5]));
    my_tri tri_6(.out(out), .in(in6), .oe(decoder_out[6]));
    my_tri tri_7(.out(out), .in(in7), .oe(decoder_out[7]));
    my_tri tri_8(.out(out), .in(in8), .oe(decoder_out[8]));
    my_tri tri_9(.out(out), .in(in9), .oe(decoder_out[9]));
    my_tri tri_10(.out(out), .in(in10), .oe(decoder_out[10]));
    my_tri tri_11(.out(out), .in(in11), .oe(decoder_out[11]));
    my_tri tri_12(.out(out), .in(in12), .oe(decoder_out[12]));
    my_tri tri_13(.out(out), .in(in13), .oe(decoder_out[13]));
    my_tri tri_14(.out(out), .in(in14), .oe(decoder_out[14]));
    my_tri tri_15(.out(out), .in(in15), .oe(decoder_out[15]));
    my_tri tri_16(.out(out), .in(in16), .oe(decoder_out[16]));
    my_tri tri_17(.out(out), .in(in17), .oe(decoder_out[17]));
    my_tri tri_18(.out(out), .in(in18), .oe(decoder_out[18]));
    my_tri tri_19(.out(out), .in(in19), .oe(decoder_out[19]));
    my_tri tri_20(.out(out), .in(in20), .oe(decoder_out[20]));
    my_tri tri_21(.out(out), .in(in21), .oe(decoder_out[21]));
    my_tri tri_22(.out(out), .in(in22), .oe(decoder_out[22]));
    my_tri tri_23(.out(out), .in(in23), .oe(decoder_out[23]));
    my_tri tri_24(.out(out), .in(in24), .oe(decoder_out[24]));
    my_tri tri_25(.out(out), .in(in25), .oe(decoder_out[25]));
    my_tri tri_26(.out(out), .in(in26), .oe(decoder_out[26]));
    my_tri tri_27(.out(out), .in(in27), .oe(decoder_out[27]));
    my_tri tri_28(.out(out), .in(in28), .oe(decoder_out[28]));
    my_tri tri_29(.out(out), .in(in29), .oe(decoder_out[29]));
    my_tri tri_30(.out(out), .in(in30), .oe(decoder_out[30]));
    my_tri tri_31(.out(out), .in(in31), .oe(decoder_out[31]));


endmodule