.eqv HEADING 0xffff8010 # Integer: An angle between 0 and 359
 # 0 : North (up)
 # 90: East (right)
 # 180: South (down)
 # 270: West (left)
.eqv MOVING 0xffff8050 # Boolean: whether or not to move
.eqv LEAVETRACK 0xffff8020 # Boolean (0 or non-0):
 # whether or not to leave a track
.eqv WHEREX 0xffff8030 # Integer: Current x-location of MarsBot
.eqv WHEREY 0xffff8040 # Integer: Current y-location of MarsBot
# Định nghĩa hằng số cho chiều dài cạnh tam giác
.eqv TRIANGLE_SIDE 50

.text
#-----------------------------------------------------------
# DRAW_TRIANGLE procedure, vẽ một tam giác
# param[in] $a0, góc của tam giác (0, 90, 180, 270)
#-----------------------------------------------------------
DRAW_TRIANGLE:
    # Đặt tọa độ ban đầu của Marsbot
    li $at, WHEREX
    li $a1, 100 # Tọa độ x ban đầu
    sw $a1, 0($at)

    li $at, WHEREY
    li $a2, 100 # Tọa độ y ban đầu
    sw $a2, 0($at)

    # Bắt đầu vẽ tam giác
    jal ROTATE        # Quay Marsbot đúng hướng
    nop

    li $t0, TRIANGLE_SIDE   # Độ dài cạnh tam giác
    li $t1, 0               # Biến đếm

    loop:
        # Di chuyển Marsbot về phía trước
        jal GO
        nop

        # Kiểm tra xem đã vẽ đủ 3 cạnh tam giác chưa
        addi $t1, $t1, 1
        beq $t1, 3, end_loop

        # Quay Marsbot 120 độ để vẽ cạnh tiếp theo
        li $a0, 120
        jal ROTATE
        nop
        j loop

    end_loop:
    jr $ra
    nop

#-----------------------------------------------------------
# GO procedure, to start running
# param[in] none
#-----------------------------------------------------------
GO: li $at, MOVING # change MOVING port
 addi $k0, $zero,1 # to logic 1,
 sb $k0, 0($at) # to start running
 nop 
 jr $ra
 nop
#-----------------------------------------------------------
# STOP procedure, to stop running
# param[in] none
#-----------------------------------------------------------
STOP: li $at, MOVING # change MOVING port to 0
 sb $zero, 0($at) # to stop
 nop
 jr $ra
 nop
#-----------------------------------------------------------
# TRACK procedure, to start drawing line 
# param[in] none
#----------------------------------------------------------- 
TRACK: li $at, LEAVETRACK # change LEAVETRACK port
 addi $k0, $zero,1 # to logic 1,
 sb $k0, 0($at) # to start tracking
 nop
 jr $ra
 nop 
#-----------------------------------------------------------
# UNTRACK procedure, to stop drawing line
# param[in] none
#----------------------------------------------------------- 
UNTRACK:li $at, LEAVETRACK # change LEAVETRACK port to 0
 sb $zero, 0($at) # to stop drawing tail
 nop
 jr $ra
 nop
#-----------------------------------------------------------
# ROTATE procedure, to rotate the robot
# param[in] $a0, An angle between 0 and 359
# 0 : North (up)
# 90: East (right)
# 180: South (down)
# 270: West (left)
#-----------------------------------------------------------
ROTATE: li $at, HEADING # change HEADING port
 sw $a0, 0($at) # to rotate robot
 nop
 jr $ra
 nop
