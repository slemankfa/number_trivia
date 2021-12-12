import 'dart:io';

String fixture(String name)=> File("test/fixtuers/$name").readAsStringSync() ;