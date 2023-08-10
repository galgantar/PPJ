import java.io.BufferedReader;
import java.io.IOException;
import java.io.StreamTokenizer;
import java.io.StringReader;

public class Parser {
    public static class Error extends Exception {
        public Error(String message) {
            super(message);
        }
    }

    public static Izraz parse(String s) throws IOException, Error {
        StreamTokenizer lexer = new StreamTokenizer(new BufferedReader(new StringReader(s)));
        lexer.resetSyntax();
        lexer.parseNumbers();
        lexer.ordinaryChar('-');
        lexer.wordChars('a', 'z');
        lexer.wordChars('A', 'Z');
        lexer.whitespaceChars(' ', ' ');
        return izraz(lexer);
    }

    // <izraz> ::= <aditivni> EOF
    public static Izraz izraz(StreamTokenizer lexer) throws IOException, Error {
        Izraz e = aditivni(lexer);
        if (lexer.nextToken() != StreamTokenizer.TT_EOF) {
            throw new Error("pričakoval EOF, dobil: " + lexer.toString());
        } else {
            return e;
        }
    }

    // <aditivni> ::= <multiplikativni> | <aditivni> + <multiplikativni> | <aditivni> - <multiplikativni>
    public static Izraz aditivni(StreamTokenizer lexer) throws IOException, Error {
        // Pozor: naivna implementacija tega pravila bi takoj rekurzivno poklicala
        // funkcijo aditivni, kar bi vodilo v neskončno zanko. Temu se izognemo tako
        // da kličemo <multiplikativni> v zanki in pravilno zlagamo skupaj vsoto.
        Izraz e = multiplikativni(lexer);
        while (true) {
            switch (lexer.nextToken()) {
            case '+' :
                e = new Plus(e, multiplikativni(lexer));
                break;
            
            case '-' :
                e = new Minus(e, multiplikativni(lexer));
                break;
            
            default:
                lexer.pushBack();
                return e;
            }
        }
    }

    // <multiplikativni> ::= <nasprotni> | <multiplikativni> * <nasprotni>
    public static Izraz multiplikativni(StreamTokenizer lexer) throws IOException, Error {
        // Pozor: naivna implementacija tega pravila bi takoj rekurzivno poklicala
        // funkcijo multiplikativni, kar bi vodilo v neskončno zanko. Temu se izognemo tako
        // da kličemo <nasprotni> v zanki in pravilno zlagamo skupaj produkt.
        Izraz e = nasprotni(lexer);
        while (true) {
            switch (lexer.nextToken()) {
            case '*' :
                e = new Krat(e, nasprotni(lexer));
                break;
            default:
                lexer.pushBack();
                return e;
            }
        }
    }

    // <nasprotni> ::= - <nasprotni> | <potencni>
    public static Izraz nasprotni(StreamTokenizer lexer) throws IOException, Error {
        if (lexer.nextToken() == '-') {
            Izraz e = nasprotni(lexer);
            return new UnarniMinus(e);
        } else {
            lexer.pushBack(); // prebrali smo en znak prevec, ki ni bil -
            Izraz e = potencni(lexer);
            return e;
        }
    }

    // <potencni> ::= <aplikativni> | <aplikativni> ^ <potencni>
    public static Izraz potencni(StreamTokenizer lexer) throws IOException, Error {
        Izraz e1 = aplikativni(lexer);
        if (lexer.nextToken() == '^') {
            Izraz e2 = potencni(lexer);
            return new Potenca(e1, e2); 
        }
        else {
            lexer.pushBack();
            return e1;
        }
    }

    // <aplikativni> ::= <osnovni> | <ime_funkcije> <potencni>
    public static Izraz aplikativni(StreamTokenizer lexer) throws IOException, Error {
        if (lexer.nextToken() == StreamTokenizer.TT_WORD && Aplikacija.jeFunkcija(lexer.sval)) {
            return new Aplikacija(lexer.sval, osnovni(lexer));
        }
        else {
            lexer.pushBack();
            return osnovni(lexer);
        }
    }

    // <osnovni> ::= ( <aditivni> ) | <konstanta> | <spremenljivka>
    public static Izraz osnovni(StreamTokenizer lexer) throws IOException, Error {
        switch (lexer.nextToken()) {
            case '(':
                Izraz e = aditivni(lexer);
                if (lexer.nextToken() != ')') {
                    throw new Error("pričakoval ')', dobil " + lexer.toString());
                } else {
                    return e;
                }
            case StreamTokenizer.TT_NUMBER:
                lexer.pushBack();
                return konstanta(lexer);
            case StreamTokenizer.TT_WORD:
                lexer.pushBack();
                return spremenljivka(lexer);
            default:
                lexer.pushBack();
                throw new Error("pričakoval osnovni izraz, dobil " + lexer.toString());
        }
    }

    // <konstanta> ::= <float>
    public static Izraz konstanta(StreamTokenizer lexer) throws IOException, Error {
        if (lexer.nextToken() == StreamTokenizer.TT_NUMBER) {
            return new Konstanta(lexer.nval);
        } else {
            lexer.pushBack();
            throw new Error("pričakoval konstanto, dobil " + lexer.toString());
        }
    }

    // <spremenljivka> ::= [a-zA-Z]+
    public static Izraz spremenljivka(StreamTokenizer lexer) throws IOException, Error {
        if (lexer.nextToken() == StreamTokenizer.TT_WORD) {
            return new Spremenljivka(lexer.sval);
        } else {
            lexer.pushBack();
            throw new Error("pričakoval spremenljivko, dobil " + lexer.toString());
        }
    }
}
