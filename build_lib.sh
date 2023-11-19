#! /bin/bash

LD_LIBRARY_PATH=.
export LD_LIBRARY_PATH

object_file_name_allocate='allocate.o'
assembly_name_allocate='allocate.s'

object_file_name_deallocate='deallocate.o'
assembly_name_deallocate='deallocate.s'

lib_name='libmemorymanager.so'
echo
echo '[ASSEMBLY_FileManipulation : SimpleMemoryManager]'
echo 
echo 'Creating a shared library with both allocate and deallocate memory.'
echo 
echo '==================================='
as -g -o ${object_file_name_allocate} ${assembly_name_allocate}
as -g -o ${object_file_name_deallocate} ${assembly_name_deallocate}
ld -shared ${object_file_name_deallocate} ${object_file_name_allocate} -o ${lib_name}
echo
echo 'Shared library : OK'
as -g -o ${object_file_name_write} ${assembly_name_write}
ld -L . -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o ${executable_name_write} -lreadwrite ${object_file_name_write}
echo
echo 'Writing Executable created : OK'
echo
as -g -o ${object_file_name_read} ${assembly_name_read}
ld -L . -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o ${executable_name_read} -lreadwrite ${object_file_name_read}
echo 'Reading Executable created : OK'
echo 
echo '==============RESULTS=============='
./${executable_name_write}
echo 
echo "-->Records should be diplayed here : "
echo 
./${executable_name_read}
echo 
echo "-->And it should be exactly the same as follow : "
echo 
cat data.dat
echo


