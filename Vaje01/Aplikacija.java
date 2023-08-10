import java.util.Map;
import java.util.HashMap;
import java.util.function.Function;

public class Aplikacija extends Izraz {
	private String ime; // ime funckije npr sin
    private Izraz e;
	
	public Aplikacija(String ime, Izraz e) {
		super();
		this.ime = ime;
        this.e = e;
	}

	@Override
	public Double eval(Map<String, Double> env) {
		return funkcije.get(ime).apply(e.eval(env));
	}

	@Override
	public String toString() {
		return "(+ " + ime + " " + e + ")";
	}

    public static boolean jeFunkcija(String ime) {
        return funkcije.containsKey(ime);
    }

    static private Map<String, Function<Double, Double>> funkcije;
    static {
        funkcije = new HashMap<>();
        funkcije.put("sin", Math::sin);
        funkcije.put("cos", Math::cos);
        funkcije.put("tan", Math::tan);
        funkcije.put("log", Math::log);
    }
}
