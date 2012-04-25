package org.lmb97.util;

import net.sourceforge.stripes.config.Configuration;
import net.sourceforge.stripes.format.DefaultFormatterFactory;
import org.lmb97.data.People;
import org.lmb97.data.Seasons;

public class FormatterFactory extends DefaultFormatterFactory {

    @Override
    public void init(Configuration configuration) throws Exception {
        super.init(configuration);
        add(People.class, PersonFormatter.class);
        add(Seasons.class,SeasonFormatter.class);
    }

}
