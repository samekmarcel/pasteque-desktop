//    POS-Tech
//    Based upon Openbravo POS
//
//    Copyright (C) 2007-2009 Openbravo, S.L.
//                       2012 Scil (http://scil.coop)
//
//    This file is part of POS-Tech.
//
//    POS-Tech is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    POS-Tech is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with POS-Tech.  If not, see <http://www.gnu.org/licenses/>.

package fr.pasteque.pos.ticket;

import java.awt.image.BufferedImage;
import fr.pasteque.basic.BasicException;
import fr.pasteque.data.loader.ImageUtils;
import fr.pasteque.format.Formats;
import java.io.Serializable;
import java.util.Properties;
import org.json.JSONObject;

/**
 *
 * @author adrianromero
 *
 */
public class ProductInfoExt implements Serializable {

    private static final long serialVersionUID = 7587696873036L;
    private static final double NO_PRICE = -1.345d;

    protected String m_ID;
    protected String m_sRef;
    protected String m_sCode;
    protected String m_sName;
    protected boolean m_bCom;
    protected boolean m_bScale;
    protected String categoryid;
    protected int dispOrder;
    protected String taxcategoryid;
    protected String attributesetid;
    protected double m_dPriceBuy;
    protected double m_dPriceSell;
    protected BufferedImage m_Image;
    protected Properties attributes;
    protected boolean discountEnabled;
    protected double discountRate;
    
    /** Creates new ProductInfo */
    public ProductInfoExt() {
        m_ID = null;
        m_sRef = "0000";
        m_sCode = "0000";
        m_sName = null;
        m_bCom = false;
        m_bScale = false;
        categoryid = null;
        taxcategoryid = null;
        attributesetid = null;
        m_dPriceBuy = 0.0;
        m_dPriceSell = 0.0;
        m_Image = null;
        attributes = new Properties();
    }

    public ProductInfoExt(JSONObject o) {
        this.m_ID = o.getString("id");
        this.m_sRef = o.getString("reference");
        this.m_sCode = o.getString("barcode");
        this.m_sName = o.getString("label");
        this.m_bCom = false; // TODO: regression, add support for com products
        this.m_bScale = o.getBoolean("scaled");
        if (o.isNull("priceBuy")) {
            this.m_dPriceBuy = NO_PRICE;
        } else {
            this.m_dPriceBuy = o.getDouble("priceBuy");
        }
        this.m_dPriceSell = o.getDouble("priceSell");
        this.taxcategoryid = o.getString("taxCatId");
        this.categoryid = o.getString("categoryId");
        this.attributesetid = null; // TODO: regression, add support for attrs
        this.attributes = new Properties();
        this.discountEnabled = o.getBoolean("discountEnabled");
        this.discountRate = o.getDouble("discountRate");
        if (!o.isNull("dispOrder")) {
            this.dispOrder = o.getInt("dispOrder");
        }
    }

    public final String getID() {
        return m_ID;
    }

    public final void setID(String id) {
        m_ID = id;
    }

    public final String getReference() {
        return m_sRef;
    }

    public final void setReference(String sRef) {
        m_sRef = sRef;
    }

    public final String getCode() {
        return m_sCode;
    }

    public final void setCode(String sCode) {
        m_sCode = sCode;
    }

    public final String getName() {
        return m_sName;
    }

    public final void setName(String sName) {
        m_sName = sName;
    }

    public final boolean isCom() {
        return m_bCom;
    }

    public final void setCom(boolean bValue) {
        m_bCom = bValue;
    }

    public final boolean isScale() {
        return m_bScale;
    }

    public final void setScale(boolean bValue) {
        m_bScale = bValue;
    }

    public final int getDispOrder() {
        return this.dispOrder;
    }

    public final String getCategoryID() {
        return categoryid;
    }

    public final void setCategoryID(String sCategoryID) {
        categoryid = sCategoryID;
    }

    public final String getTaxCategoryID() {
        return taxcategoryid;
    }

    public final void setTaxCategoryID(String value) {
        taxcategoryid = value;
    }

    public final String getAttributeSetID() {
        return attributesetid;
    }
    public final void setAttributeSetID(String value) {
        attributesetid = value;
    }

    public final double getPriceBuy() {
        return m_dPriceBuy;
    }

    public final void setPriceBuy(double dPrice) {
        m_dPriceBuy = dPrice;
    }

    public final double getPriceSell() {
        return m_dPriceSell;
    }

    public final void setPriceSell(double dPrice) {
        m_dPriceSell = dPrice;
    }

    public final double getPriceSellTax(TaxInfo tax) {
        return m_dPriceSell * (1.0 + tax.getRate());
    }

    public String printPriceSell() {
        return Formats.CURRENCY.formatValue(new Double(getPriceSell()));
    }

    public String printPriceSellTax(TaxInfo tax) {
        return Formats.CURRENCY.formatValue(new Double(getPriceSellTax(tax)));
    }
    
    public BufferedImage getImage() {
        return m_Image;
    }
    public void setImage(BufferedImage img) {
        m_Image = img;
    }
    
    public String getProperty(String key) {
        return attributes.getProperty(key);
    }
    public String getProperty(String key, String defaultvalue) {
        return attributes.getProperty(key, defaultvalue);
    }
    public void setProperty(String key, String value) {
        attributes.setProperty(key, value);
    }
    public Properties getProperties() {
        return attributes;
    }

    public boolean isDiscountEnabled() {
        return this.discountEnabled;
    }
    public void enableDiscount(boolean enable) {
        this.discountEnabled = enable;
    }

    public double getDiscountRate() {
        return this.discountRate;
    }
    public void setDiscountRate(double rate) {
        this.discountRate = rate;
    }

    @Override
    public final String toString() {
        return m_sRef + " - " + m_sName;
    }

    @Override
    public int hashCode() {
        return this.m_ID.hashCode();
    }

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof ProductInfoExt)) {
            return false;
        }
        if (this.m_ID == null) {
            return ((ProductInfoExt)o).m_ID == null;
        } else {
            return this.m_ID.equals(((ProductInfoExt) o).m_ID);
        }
    }
}
