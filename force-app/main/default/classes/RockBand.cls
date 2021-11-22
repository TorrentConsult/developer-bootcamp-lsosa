/* ------------ Used in Apex Classes and Methods Live Session ------------ */

public with sharing class RockBand {

    private List<Performer> performers;
    private String bandName;

    public RockBand(String bandName, Integer yearFounded) {
        this.bandName = bandName;
        this.performers = new List<Performer>();
    }

    public void addPerformer(Performer p) {
        addPerformers(new List<Performer>{p});
    }

    public void addPerformers(List<Performer> ps) {
        performers.addAll(ps);
    }

    public class Performer {
        String name;
        String role;
        public Performer(String name, String role) {
            this.name = name;
            this.role = role;
        }
    }

    public static void run() {
        RockBand.Performer p1 = new RockBand.Performer('Thom Yorke', 'Singer');
        RockBand.Performer p2 = new RockBand.Performer('Jonny Grennwood', 'Guitarist');
        RockBand.Performer p3 = new RockBand.Performer('Ed O\'Brien', 'Guitarist');
        RockBand.Performer p4 = new RockBand.Performer('Colin Greenwood', 'Bass Guitarist');
        RockBand.Performer p5 = new RockBand.Performer('Philip Selway', 'Drummer');
        Rockband band = new Rockband('Radiohead', 1985);
        band.addPerformer(p1);
        band.addPerformer(p2);
        band.addPerformers(new List<RockBand.Performer>{p3, p4, p5});
        
    }

}