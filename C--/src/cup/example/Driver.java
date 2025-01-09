package cup.example;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java_cup.runtime.*;

class Driver 
{
	public static void main(String[] args) throws Exception 
	{ 
		Parser parser = new Parser();
        parser.parse();
        
        System.out.println("\n\n\n\n\n####   TREE   ####\n");
        
        TreeNode root = parser.getRoot();
        TreeNodePrinter printer = new TreeNodePrinter(root);
        printer.Print();
    }
}