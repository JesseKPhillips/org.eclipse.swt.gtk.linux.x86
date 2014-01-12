/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.swt.graphics.FontData;

import java.lang.all;

import org.eclipse.swt.SWT;

version(Tango){
    import tango.util.Convert;
} else { // Phobos
    import std.conv;
}

/**
 * Instances of this class describe operating system fonts.
 * <p>
 * For platform-independent behaviour, use the get and set methods
 * corresponding to the following properties:
 * <dl>
 * <dt>height</dt><dd>the height of the font in points</dd>
 * <dt>name</dt><dd>the face name of the font, which may include the foundry</dd>
 * <dt>style</dt><dd>A bitwise combination of NORMAL, ITALIC and BOLD</dd>
 * </dl>
 * If extra, platform-dependent functionality is required:
 * <ul>
 * <li>On <em>Windows</em>, the data member of the <code>FontData</code>
 * corresponds to a Windows <code>LOGFONT</code> structure whose fields
 * may be retrieved and modified.</li>
 * <li>On <em>X</em>, the fields of the <code>FontData</code> correspond
 * to the entries in the font's XLFD name and may be retrieved and modified.
 * </ul>
 * Application code does <em>not</em> need to explicitly release the
 * resources managed by each instance when those instances are no longer
 * required, and thus no <code>dispose()</code> method is provided.
 *
 * @see Font
 * @see <a href="http://www.eclipse.org/swt/">Sample code and further information</a>
 */
public final class FontData {
    /**
     * the font name
     * (Warning: This field is platform dependent)
     * <p>
     * <b>IMPORTANT:</b> This field is <em>not</em> part of the SWT
     * public API. It is marked public only so that it can be shared
     * within the packages provided by SWT. It is not available on all
     * platforms and should never be accessed from application code.
     * </p>
     */
    public String name;

    /**
     * The height of the font data in points
     * (Warning: This field is platform dependent)
     * <p>
     * <b>IMPORTANT:</b> This field is <em>not</em> part of the SWT
     * public API. It is marked public only so that it can be shared
     * within the packages provided by SWT. It is not available on all
     * platforms and should never be accessed from application code.
     * </p>
     */
    public float height = 0;

    /**
     * the font style
     * (Warning: This field is platform dependent)
     * <p>
     * <b>IMPORTANT:</b> This field is <em>not</em> part of the SWT
     * public API. It is marked public only so that it can be shared
     * within the packages provided by SWT. It is not available on all
     * platforms and should never be accessed from application code.
     * </p>
     */
    public int style;

    /**
     * the Pango string
     * (Warning: This field is platform dependent)
     * <p>
     * <b>IMPORTANT:</b> This field is <em>not</em> part of the SWT
     * public API. It is marked public only so that it can be shared
     * within the packages provided by SWT. It is not available on all
     * platforms and should never be accessed from application code.
     * </p>
     */
    public String str;

    /**
     * The locales of the font
     */
    String lang, country, variant;

/**
 * Constructs a new uninitialized font data.
 */
public this () {
    this("", 12, SWT.NORMAL);
}

/**
 * Constructs a new FontData given a string representation
 * in the form generated by the <code>FontData.toString</code>
 * method.
 * <p>
 * Note that the representation varies between platforms,
 * and a FontData can only be created from a string that was
 * generated on the same platform.
 * </p>
 *
 * @param string the string representation of a <code>FontData</code> (must not be null)
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - if the argument is null</li>
 *    <li>ERROR_INVALID_ARGUMENT - if the argument does not represent a valid description</li>
 * </ul>
 *
 * @see #toString
 */
public this(String str) {
    if (str is null) SWT.error(SWT.ERROR_NULL_ARGUMENT);
    ptrdiff_t start = 0;
    auto end = indexOf( str, '|' );
    if (end is -1 ) SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    String version1 = str[ start .. end ];
    try {
        if (Integer.parseInt(version1) !is 1) SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    } catch (NumberFormatException e) {
        SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    }

    start = end + 1;
    end = indexOf( str, '|', start );
    if (end is -1 ) SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    String name = str[start .. end ];

    start = end + 1;
    end = indexOf( str, '|', start );
    if (end is -1 ) SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    float height = 0;
    try {
        height = Float.parseFloat(str[start .. end]);
    } catch (NumberFormatException e) {
        SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    }

    start = end + 1;
    end = indexOf( str, '|', start );
    if (end is -1 ) SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    int style = 0;
    try {
        style = Integer.parseInt( str[start .. end ]);
    } catch (NumberFormatException e) {
        SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    }

    start = end + 1;
    end = indexOf( str, '|', start );
    setName(name);
    setHeight(height);
    setStyle(style);
    if (end is -1) return;
    String platform = str[ start .. end ];

    start = end + 1;
    end = indexOf( str, '|', start );
    if (end is -1) return;
    String version2 = str[ start .. end ];

    if (platform.equals("GTK") && version2.equals("1")) {
        return;
    }
}

/**
 * Constructs a new font data given a font name,
 * the height of the desired font in points,
 * and a font style.
 *
 * @param name the name of the font (must not be null)
 * @param height the font height in points
 * @param style a bit or combination of NORMAL, BOLD, ITALIC
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - when the font name is null</li>
 *    <li>ERROR_INVALID_ARGUMENT - if the height is negative</li>
 * </ul>
 */
public this(String name, int height, int style) {
    setName(name);
    setHeight(height);
    setStyle(style);
}

/*public*/ this(String name, float height, int style) {
    setName(name);
    setHeight(height);
    setStyle(style);
}

/**
 * Compares the argument to the receiver, and returns true
 * if they represent the <em>same</em> object using a class
 * specific comparison.
 *
 * @param object the object to compare with this object
 * @return <code>true</code> if the object is the same as this object and <code>false</code> otherwise
 *
 * @see #hashCode
 */
public override equals_t opEquals (Object object) {
    if (object is this) return true;
    if( auto data = cast(FontData)object ){
        return name.equals(data.name) && height is data.height && style is data.style;
    }
    return false;
}

/**
 * Returns the height of the receiver in points.
 *
 * @return the height of this FontData
 *
 * @see #setHeight(int)
 */
public int getHeight() {
    return cast(int)(0.5f + height);
}

/*public*/ float getHeightF() {
    return height;
}

/**
 * Returns the locale of the receiver.
 * <p>
 * The locale determines which platform character set this
 * font is going to use. Widgets and graphics operations that
 * use this font will convert UNICODE strings to the platform
 * character set of the specified locale.
 * </p>
 * <p>
 * On platforms where there are multiple character sets for a
 * given language/country locale, the variant portion of the
 * locale will determine the character set.
 * </p>
 *
 * @return the <code>String</code> representing a Locale object
 * @since 3.0
 */
public String getLocale () {
    String result;
    const char sep = '_';
    if (lang !is null) {
        result ~= lang;
        result ~= sep;
    }
    if (country !is null) {
        result ~= country;
        result ~= sep;
    }
    if (variant !is null) {
        result ~= variant;
    }

    if (result) {
        if (result[$-1] is sep) {
            result = result[0 .. $ - 1];
        }
    }
getDwtLogger().trace( __FILE__, __LINE__,  "getLocal {}", result );
    return result;
}

/**
 * Returns the name of the receiver.
 * On platforms that support font foundries, the return value will
 * be the foundry followed by a dash ("-") followed by the face name.
 *
 * @return the name of this <code>FontData</code>
 *
 * @see #setName
 */
public String getName() {
    return name;
}

/**
 * Returns the style of the receiver which is a bitwise OR of
 * one or more of the <code>SWT</code> constants NORMAL, BOLD
 * and ITALIC.
 *
 * @return the style of this <code>FontData</code>
 *
 * @see #setStyle
 */
public int getStyle() {
    return style;
}

/**
 * Returns an integer hash code for the receiver. Any two
 * objects that return <code>true</code> when passed to
 * <code>equals</code> must return the same value for this
 * method.
 *
 * @return the receiver's hash
 *
 * @see #equals
 */
public override hash_t toHash () {
    return typeid(String).getHash(&name) ^ cast(int)(0.5f + height) ^ style;
}

/**
 * Sets the height of the receiver. The parameter is
 * specified in terms of points, where a point is one
 * seventy-second of an inch.
 *
 * @param height the height of the <code>FontData</code>
 *
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_INVALID_ARGUMENT - if the height is negative</li>
 * </ul>
 *
 * @see #getHeight
 */
public void setHeight(int height) {
    if (height < 0) SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    this.height = height;
    this.str = null;
}

/*public*/ void setHeight(float height) {
    if (height < 0) SWT.error(SWT.ERROR_INVALID_ARGUMENT);
    this.height = height;
    this.str = null;
}

/**
 * Sets the locale of the receiver.
 * <p>
 * The locale determines which platform character set this
 * font is going to use. Widgets and graphics operations that
 * use this font will convert UNICODE strings to the platform
 * character set of the specified locale.
 * </p>
 * <p>
 * On platforms where there are multiple character sets for a
 * given language/country locale, the variant portion of the
 * locale will determine the character set.
 * </p>
 *
 * @param locale the <code>String</code> representing a Locale object
 * @see java.util.Locale#toString
 */
public void setLocale(String locale) {
getDwtLogger().trace( __FILE__, __LINE__,  "setLocal {}", locale );
    lang = country = variant = null;
    if (locale !is null) {
        char sep = '_';
        auto length = locale.length;
        typeof(length) firstSep, secondSep;

        firstSep = indexOf( locale, sep );
        if (firstSep is -1 ) {
            firstSep = secondSep = length;
        } else {
            secondSep = indexOf( locale, sep, firstSep + 1);
            if (secondSep is -1 ) secondSep = length;
        }
        if (firstSep > 0) lang = locale[0 .. firstSep];
        if (secondSep > firstSep + 1) country = locale[firstSep + 1 .. secondSep ];
        if (length > secondSep + 1) variant = locale[secondSep + 1 .. $ ];
    }
}

/**
 * Sets the name of the receiver.
 * <p>
 * Some platforms support font foundries. On these platforms, the name
 * of the font specified in setName() may have one of the following forms:
 * <ol>
 * <li>a face name (for example, "courier")</li>
 * <li>a foundry followed by a dash ("-") followed by a face name (for example, "adobe-courier")</li>
 * </ol>
 * In either case, the name returned from getName() will include the
 * foundry.
 * </p>
 * <p>
 * On platforms that do not support font foundries, only the face name
 * (for example, "courier") is used in <code>setName()</code> and
 * <code>getName()</code>.
 * </p>
 *
 * @param name the name of the font data (must not be null)
 * @exception IllegalArgumentException <ul>
 *    <li>ERROR_NULL_ARGUMENT - when the font name is null</li>
 * </ul>
 *
 * @see #getName
 */
public void setName(String name) {
    if (name is null) SWT.error(SWT.ERROR_NULL_ARGUMENT);
    this.name = name;
    this.str = null;
}

/**
 * Sets the style of the receiver to the argument which must
 * be a bitwise OR of one or more of the <code>SWT</code>
 * constants NORMAL, BOLD and ITALIC.  All other style bits are
 * ignored.
 *
 * @param style the new style for this <code>FontData</code>
 *
 * @see #getStyle
 */
public void setStyle(int style) {
    this.style = style;
    this.str = null;
}

/**
 * Returns a string representation of the receiver which is suitable
 * for constructing an equivalent instance using the
 * <code>FontData(String)</code> constructor.
 *
 * @return a string representation of the FontData
 *
 * @see FontData
 */
public override String toString() {
    return Format( "1|{}|{}|{}|GTK|1|", getName, getHeightF, getStyle );
}

}
