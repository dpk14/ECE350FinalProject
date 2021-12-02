module ScoreDisplay #(parameter SCREEN_WIDTH = 640,
                               NUM_IMG_WIDTH = 342, NUM_HEIGHT = 46,
                               BITS_PER_COLOR = 12)
                   (clk,
                   x, y,
                   score,
                   SCORE_OFFSET,

                    // outputs
                    inside_score,
                    scoreData);

    input clk;
    input[31:0] score, SCORE_OFFSET;
    input[9:0] x;
    input[8:0] y;

    output inside_score;
    output [BITS_PER_COLOR-1:0] scoreData;

    localparam NUM_WIDTH = NUM_IMG_WIDTH / 10;


    wire [BITS_PER_COLOR-1:0] onesPlaceColorData, tensPlaceColorData, hundredsPlaceColorData;

    image #(.WIDTH(NUM_IMG_WIDTH), .HEIGHT(NUM_HEIGHT),
            .IMG_FILE("numbers_image.mem"),
            .CLR_FILE("numbers_colors.mem"))
    pipeImage(.clk(clk),
               .imgAddress(
                    inside_hundreds_place ? x - ((SCREEN_WIDTH - (NUM_WIDTH * 3)) / 2) + NUM_IMG_OFFSET_HUNDREDS + (NUM_IMG_WIDTH*(y - SCORE_OFFSET)) :
                    inside_tens_place ? x - ((SCREEN_WIDTH - NUM_WIDTH) / 2) + NUM_IMG_OFFSET_TENS + (NUM_IMG_WIDTH*(y - SCORE_OFFSET)) :
                    x - ((SCREEN_WIDTH + NUM_WIDTH) / 2) + NUM_IMG_OFFSET_ONES + (NUM_IMG_WIDTH*(y - SCORE_OFFSET))),
               .colorData(scoreData));


    wire [31:0] score_minus_100, score_minus_200, score_minus_300, score_minus_400, score_minus_500, score_minus_600, score_minus_700,
         score_minus_800, score_minus_900,
         score_ten_minus_10, score_ten_minus_20, score_ten_minus_30, score_ten_minus_40, score_ten_minus_50, score_ten_minus_60, score_ten_minus_70,
                  score_ten_minus_80, score_ten_minus_90;


    assign score_minus_100 = score - 100;
    assign score_minus_200 = score - 200;
    assign score_minus_300 = score - 300;
    assign score_minus_400 = score - 400;
    assign score_minus_500 = score - 500;
    assign score_minus_600 = score - 600;
    assign score_minus_700 = score - 700;
    assign score_minus_800 = score - 800;
    assign score_minus_900 = score - 900;

    wire[31:0] score_tens = score < 100 ? score:
                            score_minus_100 < 100 ? score_minus_100:
                            score_minus_200 < 100 ? score_minus_200:
                            score_minus_300 < 100 ? score_minus_300:
                            score_minus_400 < 100 ? score_minus_400:
                            score_minus_500 < 100 ? score_minus_500:
                            score_minus_600 < 100 ? score_minus_600:
                            score_minus_700 < 100 ? score_minus_700:
                            score_minus_800 < 100 ? score_minus_800:
                            score_minus_900 < 100 ? score_minus_900:
                            score;

    wire[31:0] NUM_IMG_OFFSET_HUNDREDS = NUM_WIDTH*(
                                    score < 100 ? 0:
                                    score_minus_100 < 100 ? 1:
                                    score_minus_200 < 100 ? 2:
                                    score_minus_300 < 100 ? 3:
                                    score_minus_400 < 100 ? 4:
                                    score_minus_500 < 100 ? 5:
                                    score_minus_600 < 100 ? 6:
                                    score_minus_700 < 100 ? 7:
                                    score_minus_800 < 100 ? 8:
                                    score_minus_900 < 100 ? 9:
                                    0);

    assign score_ten_minus_10 = score_tens - 10;
    assign score_ten_minus_20 = score_tens - 20;
    assign score_ten_minus_30 = score_tens - 30;
    assign score_ten_minus_40 = score_tens - 40;
    assign score_ten_minus_50 = score_tens - 50;
    assign score_ten_minus_60 = score_tens - 60;
    assign score_ten_minus_70 = score_tens - 70;
    assign score_ten_minus_80 = score_tens - 80;
    assign score_ten_minus_90 = score_tens - 90;

    wire[31:0] score_ones = score_tens < 10 ? score_tens:
                            score_ten_minus_10 < 10 ? score_ten_minus_10:
                            score_ten_minus_20 < 10 ? score_ten_minus_20:
                            score_ten_minus_30 < 10 ? score_ten_minus_30:
                            score_ten_minus_40 < 10 ? score_ten_minus_40:
                            score_ten_minus_50 < 10 ? score_ten_minus_50:
                            score_ten_minus_60 < 10 ? score_ten_minus_60:
                            score_ten_minus_70 < 10 ? score_ten_minus_70:
                            score_ten_minus_80 < 10 ? score_ten_minus_80:
                            score_ten_minus_90 < 10 ? score_ten_minus_90:
                            score_tens;

    wire[31:0] NUM_IMG_OFFSET_TENS = NUM_WIDTH*(
                                    score_tens < 10 ? 0:
                                    score_ten_minus_10 < 10 ? 1:
                                    score_ten_minus_20 < 10 ? 2:
                                    score_ten_minus_30 < 10 ? 3:
                                    score_ten_minus_40 < 10 ? 4:
                                    score_ten_minus_50 < 10 ? 5:
                                    score_ten_minus_60 < 10 ? 6:
                                    score_ten_minus_70 < 10 ? 7:
                                    score_ten_minus_80 < 10 ? 8:
                                    score_ten_minus_90 < 10 ? 9:
                                    0);

    wire[31:0] NUM_IMG_OFFSET_ONES = NUM_WIDTH*(score_ones);

    wire inside_y_range = y >= SCORE_OFFSET &&
                          y <= SCORE_OFFSET + NUM_HEIGHT;

    wire inside_hundreds_place = score >= 100 &&
                                 inside_y_range &&
                                 x >= (SCREEN_WIDTH - (NUM_WIDTH * 3)) / 2 &&
                                 x <= (SCREEN_WIDTH - NUM_WIDTH) / 2;

    wire inside_tens_place = score >= 10 &&
                                 inside_y_range &&
                                 x >= (SCREEN_WIDTH - NUM_WIDTH) / 2 &&
                                 x <= (SCREEN_WIDTH + NUM_WIDTH) / 2;

    wire inside_ones_place = inside_y_range &&
                             x >= (SCREEN_WIDTH + NUM_WIDTH) / 2 &&
                             x <= (SCREEN_WIDTH + (NUM_WIDTH * 3)) / 2;

    // output

    assign inside_score = inside_ones_place ||
                          (inside_tens_place && score >= 10) ||
                          (inside_hundreds_place && score >= 100);

endmodule
