.data
#Khai bao cac xau phuc vu hien thi
	message1: .asciiz "Nhap chuoi ky tu : "
	message2_error: .asciiz "Loi! Do dai chuoi ky tu nhap vao phai la boi cua 8.\nVui long nhap lai : "
	message3: .asciiz "Ban co muon nhap lai?"
	
#Cac sau ben duoi co cac khoang trang de can chinh giup viec in ra dep hon
	message4: .asciiz "     Disk 1                Disk 2                Disk 3\n"
	message5: .asciiz " --------------        --------------        --------------\n"
	open_disk: .asciiz "|     "
	close_disk: .asciiz "     |      "
	open_bracket: .asciiz "[[ "
	close_bracket: .asciiz "]]      "
	comma: .asciiz ","
	newline: .asciiz "\n"
	
#Khai bao khong gian luu tru cho chuoi nhap vao, cac o dia 
	string: .space 1000				# Chuoi nhap vao co toi da 1000 ky tu
	disk1: .space 500				# 3 o dia nhung du lieu luu tru duoc thuc te chi co 2 o nen em khai bao moi o co kich thuoc 500 byte
	disk2: .space 500				
	disk3: .space 500
	parity: .space 1000				# Vung nho de luu du lieu parity da chuyen qua he 16
	hexa: .byte '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' 
	# Mang cac ky tu bieu dien cua he 16
	
.text
main:
	la 		$s1, disk1			# Luu dia chi cua dia 1 vao $s1
	la 		$s2, disk2			# Luu dia chi cua dia 2 vao $s2
	la 		$s3, disk3			# Luu dia chi cua dia 3 vao $s3
	la 		$a2, parity			# Luu dia chi cua phan parity vao $a2
	
	li 		$v0, 4				# In ra man hinh chuoi "Nhap chuoi ky tu"
	la 		$a0, message1
	syscall
	
input_string:	
	li 		$v0, 8				# Doc chuoi co do dai toi da 1000 ky tu tu ban phim
	la 		$a0, string
	li 		$a1, 1000
	syscall
	add 		$s0, $a0, $zero			# $s0 = dia chi cua chuoi nhap vao 
	
	
#---------------------------------------------------------------------
# Chuong trinh con: Kiem tra tinh hop le cua xau nhap vao
# Cac thanh ghi su dung
# $t0: Bien dem i
# $t1: Luu dia chi cua s[i]
# $t2: Luu gia tri s[i]
# $t3: Bien tam luu do dai cua xau, phuc vu kiem tra
#---------------------------------------------------------------------
begin_check_length:
	addi 		$t0, $zero, 0 			# Khoi tao bien dem i
get_length: 
	add 		$t1, $s0, $t0 			# $t1 = $s0 + dem = dia chi cua phan tu thu i trong xau nhap vao s[i]
	lb 		$t2, 0($t1) 			# Luu s[i] vao $t2
	nop
	beq 		$t2, 10, check_length		# Kiem tra xem s[i] co phai ky tu ket thuc xau khong. Neu co, nhay den nhan check_length de kiem tra do dai
	nop
	addi 		$t0, $t0, 1			# Neu khong, tang bien den 1
	j 		get_length			# Nhay den nhan length - tiep tuc vong lap xet sang phan tu tiep theo
	nop


check_length: 
	addi 		$t3, $t0, 0			# $t3 = $t0 = do dai cua xau nhap vao
	srl  		$t3, $t3, 3			# Dich phai gia tri trong thanh ghi $t3 3 bit (Chia cho 8)
	sll 		$t3, $t3, 3			# Dich trai gia tri trong thanh ghi $t3 3 bit (Nhan voi 8)
	bne 		$t3, $t0, wrong			# Neu gia tri $t3 thu duoc khac voi gia tri $t0 ban dau thi nhay den nhan wrong de bao loi
	j 		start				# Nguoc lai, do dai chuoi hop le => Bat dau qua trinh luu vao cac o dia
	
wrong:	
	li 		$v0, 4				# In ma man hinh thong bao loi va yeu cau nguoi dung nhap lai
	la 		$a0, message2_error
	syscall
	j 		input_string			# Nhay den nhan input_string de nhap lai 1 xau moi
	
	
#---------------------------------------------------------------------
# Chuong trinh con hexadecimal: Chuyen gia tri he nhi phan sang he 16 va in gia tri ra man hinh
# Input:	$t8 - So nhi phan can chuyen
# Output:	$a0 - Gia tri he 16 khi chuyen
# Cac thanh ghi su dung:
# $t5: Chua dia chi cua mang hexa
# $t6: Chua dia chi cua phan tu tuong ung khi chuyen (dia chi thuoc mang hexa) 
#---------------------------------------------------------------------	
hexa_convert:	
	la 		$t5, hexa 			# Luu dia chi mang hexa vao $t5
	andi 		$a0, $t8, 0xf0 			# Lay AND $t8 voi 0xf0 de lay 4 bit cao (bit 4~7)
	srl 		$a0, $a0, 4			# Dich phai 4 bit gia tri $a0 de dich 4 bit vua thu duoc tu 4~7 sang 0~3 
	add 		$t6, $t5, $a0 			# t6 = t5 + a0 
	lb 		$a0, 0($t6) 			# Load ky tu hexa tuong ung vao $a0
	sb		$a0, 0($a2)			# Luu ky tu da chuyen vao mang parity		
	addi		$a2, $a2, 1			# Tang dia chi mang len 1 - luu phan tu tiep theo
	li 		$v0, 11				# In ky tu $v0 ra man hinh
	syscall
	
	andi 		$a0, $t8, 0xf			# Lay AND $t8 voi 0xf de lay 4 bit thap nhat trong $t8
	add 		$t6, $t5, $a0 			# t6 = t5 + a0
	lb 		$a0, 0($t6) 			# Load ky tu hexa tuong ung vao $a0
	sb		$a0, 0($a2)			# Luu ky tu da chuyen vao mang parity	
	addi		$a2, $a2, 1			# Tang dia chi mang len 1 - luu phan tu tiep theo
	li 		$v0, 11				# In ky tu $v0 ra man hinh
	syscall
end_hexa_convert: 
	jr 		$ra				# Quay tro lai vi tri goi ham
	
#---------------------------------------------------------------------
# Chuong trinh con print_block: In ra man hinh 1 block (4 ky tu)
# Thanh ghi duoc su dung
# $t4: dia chi block
# $t7: Bien dem cac ky tu in
#---------------------------------------------------------------------
print_block:
	lb 		$a0, 0($t4)			# Load ky tu duoc tro boi $t4 vao $a0
	li 		$v0, 11				# In $a0 ra man hinh
	syscall
	
	addi 		$t7, $t7, 1			# Tang bien dem len 1
	addi 		$t4, $t4, 1			# $t4 = $t4 + 1 - $t4 chi den phan tu tiep theo
	
	bgt 		$t7, 3, end_print_block		# Neu $t7 > 3 tuc la da in du 4 phan tu => Ket thuc chuong trinh con
	j 		print_block			# Nguoc lai tiep tuc in 

end_print_block:
	jr		$ra				# Quay tro ve chuuong trinh chinh
	
	
#---------------------------------------------------------------------
# Chuong trinh con print_closed_opend: In ra man hinh ky tu dong mo 1 o dia
#---------------------------------------------------------------------
print_closed_opend:	
	li 		$v0, 4				# In ra man hinh ky tu '|' - dong o dia 
	la 		$a0, close_disk
	syscall
	
	li 		$v0, 4				# In ra man hinh ky tu '|' - mo o dia 
	la 		$a0, open_disk
	syscall
	
end_print_closed_opend:	
	jr		$ra
	
#---------------------------------------------------------------------
# Chuong trinh con print_closed_open_bracket: In ra man hinh ky tu dong o dia va mo ngoac [[
#---------------------------------------------------------------------
print_closed_open_bracket:
	li 		$v0, 4				# In ra man hinh ky tu '|' - dong o dia 2
	la 		$a0, close_disk	
	syscall
	
	li 		$v0, 4				# In ra man hinh ky tu '[[' - mo o dia 3
	la 		$a0, open_bracket
	syscall
	
end_print_closed_open_bracket:
	jr 		$ra
	
#---------------------------------------------------------------------
# Chuong trinh con print_close_bracket_opend: In ra man hinh ky tu dong ngoac ]] va mo o dia
#---------------------------------------------------------------------
print_close_bracket_opend:
	li 		$v0, 4				# In ra man hinh ky tu dong ngoac ]]
	la 		$a0, close_bracket
	syscall
	
	li 		$v0, 4				# In ra man hinh ky tu mo o dia
	la 		$a0, open_disk
	syscall
end_print_close_bracket_opend:
	jr 		$ra	
	
#---------------------------------------------------------------------
# Chuong trinh con: Luu du lieu vao dia 1, 2, luu phan XOR vao dia 3
# Thanh ghi duoc su dung 
# $t0: Bien dem so ky tu duoc nap vao moi block
# $s4: Do dai chuoi nhap vao
# $s5: chua dia chi cua ky tu duoc luu vao o 2
# $t1: Chua ky tu luu vao o 1
# $t2: Chua ky tu luu vao o 2
# $t3: Chua ky tu luu vao o 3
# $t4: Dia chi cua block du lieu duoc nap vao tung dia
# $t7: Bien dem so ky tu duoc in ra
#---------------------------------------------------------------------
start:
	add		$s4, $t0, $zero			# Luu do dai cua xau vao thanh ghi $s4 
	li 		$v0, 4
	la 		$a0, message4			# In ra man hinh xau 'Disk1     Disk2      Disk3'
	syscall
	li 		$v0, 4
	la 		$a0, message5			# In ra man hinh cac dau gach tuong trung cho khung tren cua o dia
	syscall	
disk12:
	addi 		$t0, $zero, 0			# Khoi tao bien dem cho du lieu
	
	li 		$v0, 4				# In ra man minh dau '|' 
	la 		$a0, open_disk
	syscall
	
disk12_store_d1:	
	lb 		$t1, 0($s0)			# Load ky tu trong chuoi vao $t1
	addi 		$s4, $s4, -1			# Giam do dai cua chuoi di 1
	sb 		$t1, 0($s1)			# Luu ky tu vua lay duoc vao o dia 1
	addi 		$s1, $s1, 1			# Tang dia chi cua o dia 1 len 1 -  de luu ky tu tiep theo
	
disk12_store_d2:	
	add 		$s5, $s0, 4			# $s5 = $s0 + 4 = dia chi cua khoi du lieu tiep theo
	lb 		$t2, 0($s5)			# Load ky tu dau tien trong khoi duoc tro toi boi $s5 vao $t2
	addi 		$s4, $s4, -1			# Giam do dai cua chuoi di 1
	sb 		$t2, 0($s2)			# Luu ky tu vua lay duoc vao o dia 2
	addi 		$s2, $s2, 1			# Tang dia chi cua o dia 2 len 1 - de luu ky tu tiep theo
	
disk12_store_d3:	
	xor 		$t3, $t1, $t2			# Lay XOR 2 ky tu vua lay duoc ($t1 XOR $t2) va luu ket qua vao $t3
	sb  		$t3, 0($s3)			# Luu gia tri XOR thu duoc vao o dia 3
	
	addi 		$s3, $s3, 1			# Tang dia chi cu ao dia 3 len 1 - de luu ky tu tiep theo
	addi 		$t0, $t0, 1			# Tang bien dem du lieu len 1
	addi 		$s0, $s0, 1			# Tang dia chi cua xau len 1, chuyen qua ky tu tiep theo
	
	bgt 		$t0, 3, disk12_print_d1		# Neu $t0 > 3 tuc la da lay du 1 block (4 phan tu) chuyen qua buoc in
	j 		disk12_store_d1			# Nguoc lai, nhay ve nhan disk12_store_d1 thuc hien lai cac thao tac tren 

disk12_print_d1:
	addi 		$t4, $s1, -4			# Gan $t4 = dia chi dau cua block du lieu duoc luu vao o 1
	li		$t7, 0				# Khoi tao bien dem so ky tu duoc in ra 
	jal 		print_block			# Nhay den chuong tirnh con in block
	nop
	jal 		print_closed_opend		# Nhay den chuong trinh con in ky tu dong mo o dia

disk12_print_d2:
	addi		$t4, $s2, -4			# Gan $t4 = dia chi dau cua block du lieu duoc luu vao o 2
	li		$t7, 0				# Khoi tao bien dem so ky tu duoc in ra 
	jal 		print_block			# Nhay den chuong tirnh con in block
	nop	
	jal		print_closed_open_bracket	# Nhay den chuong trinh con in ky tu dong o dia, mo ngoac [[

	
disk12_print_d3:
	li 		$t7, 0				# Khoi tao 1 biem dem
	addi		$t4, $s3, -4			# Gan $t4 = dia chi dau cua block du lieu duoc luu vao o 3
disk12_loop_d3:
	lb 		$t8, 0($t4)			# Load byte du lieu duoc tro toi boi $t4 vao $t8
	jal 		hexa_convert			# Chuyen qua chuong trinh con hexa_convert de chuyen tu he nhi phan sang he 16 va in ra man hinh
	
	li 		$v0, 4				# In dau phay 							
	la 		$a0, comma
	syscall
	
	addi 		$t7, $t7, 1			# Tang bien dem len 1
	addi 		$t4, $t4, 1			# $t4 = $t4 + 1 - $t4 chi den phan tu tiep theo 
	
	bgt 		$t7, 2, disk12_end_print_d3	# Neu $t7 > 2 => nhay den nhan disk12_end_print_d3: khong in them dau phay nua
	j 		disk12_loop_d3					
		
disk12_end_print_d3:	
	lb 		$t8, 0($t4)			# Load gia tri cuoi vao $t8
	jal 		hexa_convert			# Chuyen qua he 16 va in ra man hinh

end_disk12:	
	li 		$v0, 4				# In ra man hinh ky tu ']]" - dong o dia 3, hoan thanh viec in cho moi block o ca 3 o du lieu
	la 		$a0, close_bracket
	syscall
	
	li 		$v0, 4				# Xuong dong
	la 		$a0, newline
	syscall
	
	beq 		$s4, 0, end_disk		# Kiem tra xem da luu het cac ky tu chua, neu roi nhay den nhan end_disk - ket thuc viec luu va in. Nguoc lai tiep tuc qua trinh
	
	
#---------------------------------------------------------------------
# Chuong trinh con: Luu du lieu vao dia 1, 3, luu phan XOR vao dia 2
# Thanh ghi duoc su dung 
# $t0: Bien dem so ky tu duoc nap vao moi block
# $s4: Do dai chuoi nhap vao
# $s5: chua dia chi cua ky tu duoc luu vao o 3
# $t1: Chua ky tu luu vao o 1
# $t2: Chua ky tu luu vao o 3
# $t3: Chua ky tu luu vao o 2
# $t4: Dia chi cua block du lieu duoc nap vao tung dia
# $t7: Bien dem so ky tu duoc in ra
#---------------------------------------------------------------------	
disk_13:	
	addi 		$s0, $s0, 4			# $s0 = $s0 + 4 - tro toi block tiep theo
	addi 		$t0, $zero, 0			# Khoi tao bien dem cho du lieu
	
	li 		$v0, 4				# In ra man minh dau '|' - mo o dia
	la 		$a0, open_disk
	syscall
		
disk13_store_d1:	
	lb 		$t1, 0($s0)			# Load ky tu trong chuoi vao $t1
	addi 		$s4, $s4, -1			# Giam do dai cua chuoi di 1
	sb 		$t1, 0($s1)			# Luu ky tu vua lay duoc vao o dia 1
	addi 		$s1, $s1, 1			# Tang dia chi cua o dia 1 len 1 -  de luu ky tu tiep theo
	
disk13_store_d3:	
	add 		$s5, $s0, 4			# $s5 = $s0 + 4 = dia chi cua khoi du lieu tiep theo
	lb 		$t2, 0($s5)			# Load ky tu dau tien trong khoi duoc tro toi boi $s5 vao $t2
	addi 		$s4, $s4, -1			# Giam do dai cua chuoi di 1
	sb 		$t2, 0($s3)			# Luu ky tu vua lay duoc vao o dia 3
	addi	 	$s3, $s3, 1			# Tang dia chi cua o dia 3 len 1 -  de luu ky tu tiep theo
	
disk13_store_d2:	
	xor 		$t3, $t1, $t2			# Lay XOR 2 ky tu vua lay duoc ($t1 XOR $t2) va luu ket qua vao $t3
	sb		$t3, 0($s2)			# Luu gia tri XOR thu duoc vao o dia 2
	addi 		$s2, $s2, 1			# Tang dia chi cu ao dia 2 len 1 - de luu ky tu tiep theo
	addi 		$t0, $t0, 1			# Tang bien dem du lieu len 1
	addi 		$s0, $s0, 1			# Tang dia chi cua xau len 1, chuyen qua ky tu tiep theo
	
	bgt 		$t0, 3, disk13_print_d1		# Neu $t0 > 3 tuc la da lay du 1 block (4 phan tu) chuyen qua buoc in
	j 		disk13_store_d1			# Nguoc lai, nhay ve nhan disk13_store_d1 thuc hien lai cac thao tac tren 
	

	
disk13_print_d1:
	li		$t7, 0				# Gan $t4 = dia chi dau cua block du lieu duoc luu vao o 1
	addi		$t4, $s1, -4			# Khoi tao bien dem so ky tu duoc in ra 
	jal 		print_block			# Nhay den chuong tirnh con in block
	nop
	jal 		print_closed_open_bracket
	
	li		$t7, 0
	addi		$t4, $s2, -4
	
disk13_print_d2:
	lb 		$t8, 0($t4)			# Load byte du lieu duoc tro toi boi $t4 vao $t8
	jal 		hexa_convert			# Chuyen qua chuong trinh con hexa_convert de chuyen tu he nhi phan sang he 16 va in ra man hinh
	
	li 		$v0, 4				# In ra man hinh dau phay
	la 		$a0, comma
	syscall
	
	addi 		$t7, $t7, 1			# Tang bien dem len 1
	addi 		$t4, $t4, 1			# $t4 = $t4 + 1 - $t4 chi den phan tu tiep theo 
	
	bgt 		$t7, 2, disk13_next_d3		# Neu $t7 > 2 => nhay den nhan disk13_nd3 khong in them dau phay nua
	j 		disk13_print_d2
			
disk13_next_d3:	
	lb 		$t8, 0($t4)			# Load gia tri cuoi vao $t8
	jal 		hexa_convert			# Chuyen qua he 16 va in ra man hinh
	nop
	jal 		print_close_bracket_opend	# Nhay den chuong trinh con in ky tu dong ngoac ]] mo o dia

disk13_print_d3:
	li 		$t7, 0				# Khoi tao 1 biem dem
	addi 		$t4, $s3, -4			# Gan $t4 = dia chi dau cua block du lieu duoc luu vao o 3
	jal 		print_block			# Nhay den chuong tirnh con in block

end_disk13:	
	li 		$v0, 4				# In ra man hinh ky tu ']]" - dong o dia 3, hoan thanh viec in cho moi block o ca 3 o du lieu
	la		$a0, close_disk
	syscall
	
	li 		$v0, 4				# xuong dong
	la 		$a0, newline
	syscall
	
	beq 		$s4, 0, end_disk		# Kiem tra xem da luu het cac ky tu chua, neu roi nhay den nhan end_disk - ket thuc viec luu va in. Nguoc lai tiep tuc qua trinh


#---------------------------------------------------------------------
# Chuong trinh con: Luu du lieu vao dia 2, 3, luu phan XOR vao dia 1
# Thanh ghi duoc su dung 
# $t0: Bien dem so ky tu duoc nap vao moi block
# $s4: Do dai chuoi nhap vao
# $s5: chua dia chi cua ky tu duoc luu vao o 1
# $t1: Chua ky tu luu vao o 2
# $t2: Chua ky tu luu vao o 3
# $t3: Chua ky tu luu vao o 1
# $t4: Dia chi cua block du lieu duoc nap vao tung dia
# $t7: Bien dem so ky tu duoc in ra
#---------------------------------------------------------------------	
disk23:		
	addi 		$s0, $s0, 4			# $s0 = $s0 + 4 - tro toi block tiep theo
	addi 		$t0, $zero, 0			# Khoi tao bien dem cho du lieu
		
	li 		$v0, 4				# In ra man minh dau '|' - mo o dia
	la 		$a0, open_bracket
	syscall
	
disk23_store_d2:	
	lb 		$t1, 0($s0)			# Load ky tu trong chuoi vao $t1
	addi 		$s4, $s4, -1			# Giam do dai cua chuoi di 1
	sb 		$t1, 0($s2)			# Luu ky tu vua lay duoc vao o dia 2
	addi 		$s2, $s2, 1			# Tang dia chi cua o dia 2 len 1 -  de luu ky tu tiep theo
	
disk23_store_d3:	
	add 		$s5, $s0, 4			# $s5 = $s0 + 4 = dia chi cua khoi du lieu tiep theo
	lb 		$t2, 0($s5)			# Load ky tu dau tien trong khoi duoc tro toi boi $s5 vao $t2
	addi 		$s4, $s4, -1			# Giam do dai cua chuoi di 1
	sb 		$t2, 0($s3)			# Luu ky tu vua lay duoc vao o dia 3
	addi 		$s3, $s3, 1			# Tang dia chi cua o dia 3 len 1 -  de luu ky tu tiep theo
	
disk23_store_d1:	
	xor 		$t3, $t1, $t2			# Tang dia chi cu ao dia 3 len 1 - de luu ky tu tiep theo
	sb		$t3, 0($s1)			# Luu gia tri XOR thu duoc vao o dia 1
	
	
	addi 		$s1, $s1, 1			# Tang dia chi cu ao dia 1 len 1 - de luu ky tu tiep theo
	addi 		$t0, $t0, 1			# Tang bien dem du lieu len 1
	addi 		$s0, $s0, 1			# Tang dia chi cua xau len 1, chuyen qua ky tu tiep theo
	
	bgt 		$t0, 3, disk23_print		# Neu $t0 > 3 tuc la da lay du 1 block (4 phan tu) chuyen qua buoc in
	j 		disk23_store_d2			# Nguoc lai, nhay ve nhan disk12_store_d2 thuc hien lai cac thao tac tren 
	
disk23_print:	
	li 		$t7, 0
	addi 		$t4, $s1, -4
	
disk23_print_d1:
	lb 		$t8, 0($t4)			# Load byte du lieu duoc tro toi boi $t4 vao $t8
	jal 		hexa_convert			# Chuyen qua chuong trinh con hexa_convert de chuyen tu he nhi phan sang he 16 va in ra man hinh
	
	li 		$v0, 4				# In ra man hinh dau phay
	la 		$a0, comma
	syscall
	
	addi 		$t7, $t7, 1			# Tang bien dem len 1
	addi 		$t4, $t4, 1			# $t4 = $t4 + 1 - $t4 chi den phan tu tiep theo 
	
	bgt 		$t7, 2, disk23_next_d2		# Neu $t7 > 2 => nhay den nhan disk23_next_d2: khong in them dau phay nua
	j 	 	disk23_print_d1	
		
disk23_next_d2:	
	lb 		$t8, 0($t4)			# Load gia tri cuoi vao $t8
	jal 		hexa_convert			# Chuyen qua he 16 va in ra man hinh
	nop
	jal		print_close_bracket_opend 	# Nhay den chuong trinh con in ra man hinh ky tu dong ngoac ]], ky tu mo o dia
		
disk23_print_d2:
	li 		$t7, 0				# Khoi tao 1 biem dem
	addi 		$t4, $s2, -4			# Gan $t4 = dia chi dau cua block du lieu duoc luu vao o 2
	jal 		print_block			# Nhay den chuong tirnh con in block

	nop
	jal 		print_closed_opend		# Nhay den chuong trinh con in ra man hinh ky tu dong mo o dia
		
disk23_print_d3:
	li 		$t7, 0				# Khoi tao 1 biem dem
	addi		$t4, $s3, -4			# Gan $t4 = dia chi dau cua block du lieu duoc luu vao o 3
	jal		print_block			# Nhay den chuong tirnh con in block
	
end_3:	
	li 		$v0, 4				# In ra man hinh ky tu dong o dia 
	la 		$a0, close_disk
	syscall
	li 		$v0, 4				# Xuong dong
	la 		$a0, newline
	syscall
	
	beq 		$s4, 0, end_disk		# Kiem tra xem da luu het cac ky tu chua, neu roi nhay den nhan end_disk - ket thuc viec luu va in. Nguoc lai tiep tuc qua trinh
	
continue: 
	addi 		$s0, $s0, 4			# Neu van con ky tu thi tang $s0 len 4 den chuyen qua block tiep theo va lap lai quy trinh
	j 		disk12
	
############################   Ket thuc mo phong   ####################################
end_disk:	
	li 		$v0, 4				# In ra man hinh cac dau gach ngang tuong trung cho canh duoi cua cac o dia
	la 		$a0, message5
	syscall				

#---------------------------------------------------------------------
# Chuong trinh con ask: Hien thi ra man hinh thong bao hoi nguoi dung co muon nhap lai khong
#---------------------------------------------------------------------	
ask:	
	li 		$v0, 50				# Hien thi ra cua so thong bao nguoi dung co muon nhap lai
	la 		$a0, message3
	syscall
	
	beq 		$a0, 0, clear			# Neu $a0 = 0 (tuc la nguoi dung chon co) nhay den nhan clear
	nop
	j 		exit				# Nguoc lai nhay den nhan exit de ket thuc chuong trinh
	nop


#---------------------------------------------------------------------
# Chuong trinh con clear: Dat lai bo nho va thuc hien lai chuong trinh
#---------------------------------------------------------------------	
clear:	
	la 		$s0, string			# Gan $s0 = dia chi cua chuoi nhap vao
clear_string:
	lb		$t0, 0($s0)			# Lay ra ky tu dang duoc tro toi boi $s0
	beq		$t0, 10, clear_parity		# So sanh ky tu do voi ky tu '\n', neu bang chuyen qua nhan clear_parity
	sb 		$zero, 0($s0)			# Nguoc lai gan 0 vao vi tri do
	addi 		$s0, $s0, 1			# Tang con tro dia chi cua chuoi len 1 - xet tiep sang phan tu tiep theo
	j 		clear_string						

clear_parity:
	la		$a2, parity			# Gan $s1 = dia chi cua mang parity
clear_parity_loop:
	lb		$t4, 0($a2)			# Lay ra ky tu dang duoc tro toi boi $a2
	beq		$t4, 0, clear_disk1		# So sanh ky tu do voi ky tu null, neu bang chuyen qua nhan clear_disk1
	sb 		$zero, 0($a2)			# Nguoc lai gan 0 vao vi tri do
	addi 		$a2, $a2, 1			# Tang con tro parity len 1 - xet tiep sang phan tu tiep theo
	j 		clear_parity_loop

clear_disk1:
	la		$s1, disk1			# Gan $s1 = dia chi cua o dia 1
clear_disk1_loop:
	lb		$t1, 0($s1)			# Lay ra ky tu dang duoc tro toi boi $s1
	beq		$t1, 0, clear_disk2		# So sanh ky tu do voi ky tu null, neu bang chuyen qua nhan clear_disk2
	sb 		$zero, 0($s1)			# Nguoc lai gan 0 vao vi tri do
	addi 		$s1, $s1, 1			# Tang con tro $s1 len 1 - xet tiep sang phan tu tiep theo
	j 		clear_disk1_loop
	
clear_disk2:
	la		$s2, disk2			# Gan $s2 = dia chi cua o dia 2
clear_disk2_loop:
	lb		$t2, 0($s2)			# Lay ra ky tu dang duoc tro toi boi $s2
	beq		$t2, 0, clear_disk3		# So sanh ky tu do voi ky tu null, neu bang chuyen qua nhan clear_disk3
	sb 		$zero, 0($s2)			# Nguoc lai gan 0 vao vi tri do
	addi 		$s2, $s2, 1			# Tang con tro $s2 len 1 - xet tiep sang phan tu tiep theo
	j 		clear_disk2_loop

clear_disk3:
	la		$s3, disk3			# Gan $s3 = dia chi cua o dia 3
clear_disk3_loop:
	lb		$t3, 0($s3)			# Lay ra ky tu dang duoc tro toi boi $s3
	beq		$t3, 0, main			# So sanh ky tu do voi ky tu null, neu bang chuyen den nhan main de thuc hien lai chuong trinh
	sb 		$zero, 0($s3)			# Nguoc lai gan 0 vao vi tri do
	addi 		$s3, $s3, 1			# Tang con tro $s3 len 1 - xet tiep sang phan tu tiep theo
	j 		clear_disk3_loop


exit:	
	li 		$v0, 10				# Thoat khoi chuong trinh
	syscall

