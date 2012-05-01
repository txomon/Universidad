/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.util;

import net.sourceforge.stripes.validation.DateTypeConverter;

/**
 *
 * @author javier
 */
public class NormalDateTimeTypeConverter extends DateTypeConverter {
  private static final String[] TIME_FORMAT = { "HH:mm","yyyy/MM/dd HH:mm" };
  @Override
  protected String[] getFormatStrings() {
    return TIME_FORMAT;
  }
}