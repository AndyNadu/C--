package cup.example;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;
import java.lang.*;
import java.io.InputStreamReader;

%%

%class Lexer
%implements sym
%public
%unicode
%line
%column
%cup
%char
%{
	

    public Lexer(ComplexSymbolFactory sf, java.io.InputStream is){
		this(is);
        symbolFactory = sf;
    }
	public Lexer(ComplexSymbolFactory sf, java.io.Reader reader){
		this(reader);
        symbolFactory = sf;
    }
    
    private StringBuffer sb;
    private ComplexSymbolFactory symbolFactory;
    private int csline,cscolumn;

    public Symbol symbol(String name, int code){
		return symbolFactory.newSymbol(name, code,
						new Location(yyline+1,yycolumn+1, yychar), // -yylength()
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength())
				);
    }
    public Symbol symbol(String name, int code, String lexem){
	return symbolFactory.newSymbol(name, code, 
						new Location(yyline+1, yycolumn +1, yychar), 
						new Location(yyline+1,yycolumn+yylength(), yychar+yylength()), lexem);
    }
    
    protected void emit_warning(String message){
    	System.out.println("scanner warning: " + message + " at : 2 "+ 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
    
    protected void emit_error(String message){
    	System.out.println("scanner error: " + message + " at : 2" + 
    			(yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}

Newline    = \r | \n | \r\n
Whitespace = [ \t\f] | {Newline}
Number     = [0-9]+
ID         = [a-zA-Z_][a-zA-Z0-9_]*
String	   = \"([^\"\\n])*\"

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}
TraditionalComment = "/*" {CommentContent} \*+ "/"
EndOfLineComment = "//" [^\r\n]* {Newline}
CommentContent = ( [^*] | \*+[^*/] )*

ident = ([:jletter:] | "_" ) ([:jletterdigit:] | [:jletter:] | "_" )*


%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}

%state CODESEG

%%  

<YYINITIAL> {
 {EndOfLineComment} { }
  {Whitespace} {                              }
 
  "int"             { return symbolFactory.newSymbol("INT", INT); }
  "bool"            { return symbolFactory.newSymbol("BOOL", BOOL); }
  "void"            { return symbolFactory.newSymbol("VOID", VOID); }
  "true"            { return symbolFactory.newSymbol("TRUE", TRUE); }
  "false"           { return symbolFactory.newSymbol("FALSE", FALSE); }
  "if"              { return symbolFactory.newSymbol("IF", IF); }
  "else"            { return symbolFactory.newSymbol("ELSE", ELSE); }
  "while"           { return symbolFactory.newSymbol("WHILE", WHILE); }
  "return"          { return symbolFactory.newSymbol("RETURN", RETURN); }
  "cin"             { return symbolFactory.newSymbol("CIN", CIN); }
  "cout"            { return symbolFactory.newSymbol("COUT", COUT); }
  
  "{"          		{ return symbolFactory.newSymbol("LBRACE", LBRACE); }
  "}"          		{ return symbolFactory.newSymbol("RBRACE", RBRACE); }
  "("          		{ return symbolFactory.newSymbol("LPAREN", LPAREN); }
  ")"               { return symbolFactory.newSymbol("RPAREN", RPAREN); }
  "["               { return symbolFactory.newSymbol("LBRACKET", LBRACKET); }
  "]"               { return symbolFactory.newSymbol("RBRACKET", RBRACKET); }
  ","               { return symbolFactory.newSymbol("COMMA", COMMA); }
  ";"               { return symbolFactory.newSymbol("SEMI", SEMI); }
  "="               { return symbolFactory.newSymbol("EQUAL", EQUAL); }
  "+"               { return symbolFactory.newSymbol("PLUS", PLUS); }
  "-"               { return symbolFactory.newSymbol("MINUS", MINUS); }
  "*"               { return symbolFactory.newSymbol("TIMES", TIMES); }
  "/"               { return symbolFactory.newSymbol("DIVIDE", DIVIDE); }
  "!"               { return symbolFactory.newSymbol("NOT", NOT); }
  "&&"              { return symbolFactory.newSymbol("ANDAND", ANDAND); }
  "||"              { return symbolFactory.newSymbol("OROR", OROR); }
  "=="              { return symbolFactory.newSymbol("EQEQ", EQEQ); }
  "!="              { return symbolFactory.newSymbol("NOTEQ", NOTEQ); }
  "<"               { return symbolFactory.newSymbol("LESS", LESS); }
  ">"               { return symbolFactory.newSymbol("GREATER", GREATER); }
  "<="              { return symbolFactory.newSymbol("LESSEQ", LESSEQ); }
  ">="              { return symbolFactory.newSymbol("GREATEREQ", GREATEREQ); }
  "<<"             { return symbolFactory.newSymbol("LTLT", LTLT); }
  ">>"             { return symbolFactory.newSymbol("GTGT", GTGT); }
 
  
  {ID}           { return symbolFactory.newSymbol("ID", ID, yytext()); }
  {String}      { return symbolFactory.newSymbol("STRINGLITERAL", STRINGLITERAL, yytext()); }
  {Number}     { return symbolFactory.newSymbol("INTLITERAL", INTLITERAL, Integer.parseInt(yytext())); }
}



// error fallback
.|\n          { emit_warning("Unrecognized character '" +yytext()+"' -- ignored"); }
