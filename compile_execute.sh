#! /bin/bash


object_file_name_allocate='allocate.o'
assembly_name_allocate='allocate.s'

object_file_name_deallocate='deallocate.o'
assembly_name_deallocate='deallocate.s'

read_from_file_code="read.s"
object_read="read.o"

object_file_name_write_buffer='bufferread.o'
assembly_name_write_buffer='bufferread.s'

final_executable="read_with_memory"
echo
echo '[ASSEMBLY_FileManipulation : SimpleMemoryManager]'
echo 
echo 'Creating a shared library with both allocate and deallocate memory.'
echo 
echo '==================================='
as -g -o ${object_file_name_allocate} ${assembly_name_allocate}
as -g -o ${object_file_name_deallocate} ${assembly_name_deallocate}
as -g -o ${object_read} ${read_from_file_code}
as -g -o ${object_file_name_write_buffer} ${assembly_name_write_buffer}
ld ${object_read} ${object_file_name_deallocate} ${object_file_name_allocate} ${object_file_name_write_buffer} -o ${final_executable} 
echo
echo 'Writing Executable created : OK'
echo 
echo '==============RESULTS=============='
echo 
echo "-->Records should be diplayed here : "
echo 
./${final_executable}
echo 
echo "-->And it should be exactly the same as follow : "
echo 
cat data.dat
echo


