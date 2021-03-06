//    Openbravo POS is a point of sales application designed for touch screens.
//    Copyright (C) 2007-2009 Openbravo, S.L.
//    http://www.openbravo.com/product/pos
//
//    This file is part of Openbravo POS.
//
//    Openbravo POS is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Openbravo POS is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Openbravo POS.  If not, see <http://www.gnu.org/licenses/>.
package fr.pasteque.pos.ticket;

import java.awt.image.BufferedImage;
import java.io.Serializable;
import org.json.JSONObject;

/**
 *
 * @author  Adrian
 * @version 
 */
public class CategoryInfo implements Serializable {

    private static final long serialVersionUID = 8612449444103L;
    private String m_sID;
    private String parentId;
    private String m_sName;
    private String m_sRef;
    private Integer dispOrder;
    private BufferedImage m_Image;

    /** Creates new CategoryInfo */
    public CategoryInfo(String id, String ref, String name, BufferedImage image) {
        m_sID = id;
        m_sName = name;
	m_sRef = ref;
        m_Image = image;
    }

    public CategoryInfo(JSONObject o) {
        this.m_sID = o.getString("id");
        this.m_sName = o.getString("label");
        if (!o.isNull("reference")) {
            this.m_sRef = o.getString("reference");
        }
        if (!o.isNull("parentId")) {
            this.parentId = o.getString("parentId");
        }
        if (!o.isNull("dispOrder")) {
            this.dispOrder = o.getInt("dispOrder");
        }
        this.m_Image = null;
    }

    public void setID(String sID) {
        m_sID = sID;
    }

    public String getID() {
        return m_sID;
    }

    public String getReference() {
    	return m_sRef;
    }

    public void setReference(String sRef) {
    	m_sRef = sRef;
    }

    public String getName() {
        return m_sName;
    }

    public void setName(String sName) {
        m_sName = sName;
    }

    public String getParentId() {
        return this.parentId;
    }
    public Integer getDispOrder() {
        return this.dispOrder;
    }

    public BufferedImage getImage() {
        return m_Image;
    }

    public void setImage(BufferedImage img) {
        m_Image = img;
    }

    @Override
    public String toString() {
        return m_sName;
    }

}
