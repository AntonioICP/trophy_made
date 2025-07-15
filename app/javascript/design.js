(function(fabric) {
    'use strict';

    // Constants
    const DEFAULT_DIAMETER = 250;
    const DEFAULT_FONT_SIZE = 24;
    const DEFAULT_FONT_FAMILY = 'Times New Roman';
    const DEFAULT_FILL = '#000';
    const DEGREES_TO_RADIANS = Math.PI / 180;

    /**
     * CurvedText object for fabric.js
     * Creates text that follows a circular path
     * @author Arjan Haverkamp (av01d)
     * @date January 2018
     */
    fabric.CurvedText = fabric.util.createClass(fabric.Object, {
      type: 'curved-text',
      diameter: DEFAULT_DIAMETER,
      kerning: 0,
      text: '',
      flipped: false,
      fill: DEFAULT_FILL,
      fontFamily: DEFAULT_FONT_FAMILY,
      fontSize: DEFAULT_FONT_SIZE,
      fontWeight: 'normal',
      fontStyle: '',

      cacheProperties: fabric.Object.prototype.cacheProperties.concat(
        'diameter', 'kerning', 'flipped', 'fill', 'fontFamily',
        'fontSize', 'fontWeight', 'fontStyle', 'strokeStyle', 'strokeWidth'
      ),

      strokeStyle: null,
      strokeWidth: 0,

      /**
       * Initialize the CurvedText object
       * @param {string} text - The text to display
       * @param {Object} options - Configuration options
       */
      initialize: function(text, options) {
        options = options || {};
        this.text = text;

        this.callSuper('initialize', options);
        this.set('lockUniScaling', true);

        // Draw curved text and set dimensions
        const canvas = this.getCircularText();
        this._trimCanvas(canvas);
        this.set('width', canvas.width);
        this.set('height', canvas.height);
      },

      /**
       * Get font declaration string for canvas context
       * @returns {string} Font declaration
       */
      _getFontDeclaration: function() {
        return [
          fabric.isLikelyNode ? this.fontWeight : this.fontStyle,
          fabric.isLikelyNode ? this.fontStyle : this.fontWeight,
          this.fontSize + 'px',
          fabric.isLikelyNode ? ('"' + this.fontFamily + '"') : this.fontFamily
        ].join(' ');
      },

      /**
       * Trim empty space from canvas
       * @param {HTMLCanvasElement} canvas - Canvas to trim
       */
      _trimCanvas: function(canvas) {
        const ctx = canvas.getContext('2d');
        const width = canvas.width;
        const height = canvas.height;
        const pixels = { x: [], y: [] };
        const imageData = ctx.getImageData(0, 0, width, height);
        const sortFunction = (a, b) => a - b;

        // Find all non-transparent pixels
        for (let y = 0; y < height; y++) {
          for (let x = 0; x < width; x++) {
            const alphaIndex = ((y * width + x) * 4) + 3;
            if (imageData.data[alphaIndex] > 0) {
              pixels.x.push(x);
              pixels.y.push(y);
            }
          }
        }

        if (pixels.x.length === 0) return;

        pixels.x.sort(sortFunction);
        pixels.y.sort(sortFunction);

        const lastPixelIndex = pixels.x.length - 1;
        const trimmedWidth = pixels.x[lastPixelIndex] - pixels.x[0];
        const trimmedHeight = pixels.y[lastPixelIndex] - pixels.y[0];

        const trimmedImageData = ctx.getImageData(
          pixels.x[0], pixels.y[0],
          trimmedWidth, trimmedHeight
        );

        canvas.width = trimmedWidth;
        canvas.height = trimmedHeight;
        ctx.putImageData(trimmedImageData, 0, 0);
      },

      /**
       * Create circular text on canvas
       * @returns {HTMLCanvasElement} Canvas with circular text
       */
      getCircularText: function() {
        let text = this.text;
        const diameter = 2000 - this.diameter;
        const flipped = this.flipped;
        const kerning = this.kerning;
        const fill = this.fill;

        let inwardFacing = true;
        let startAngle = 0;
        const clockwise = -1;

        if (flipped) {
          startAngle = 180;
          inwardFacing = false;
        }

        startAngle *= DEGREES_TO_RADIANS;

        // Calculate text height
        const textHeight = this._getTextHeight(text);

        // Create and setup canvas
        const canvas = fabric.util.createCanvasElement();
        const ctx = canvas.getContext('2d');
        canvas.width = canvas.height = diameter;
        ctx.font = this._getFontDeclaration();

        // Reverse text for inward facing
        if (inwardFacing) {
          text = text.split('').reverse().join('');
        }

        // Setup canvas transformation
        ctx.translate(diameter / 2, diameter / 2);
        startAngle += (Math.PI * !inwardFacing);
        ctx.textBaseline = 'middle';
        ctx.textAlign = 'center';

        // Calculate center alignment rotation
        startAngle = this._calculateCenterAlignment(ctx, text, startAngle, diameter, textHeight,
  kerning, clockwise);
        ctx.rotate(startAngle);

        // Draw each character
        this._drawCharacters(ctx, text, diameter, textHeight, kerning, fill, inwardFacing,
  clockwise);

        return canvas;
      },

      /**
       * Get text height using DOM measurement
       * @param {string} text - Text to measure
       * @returns {number} Text height in pixels
       */
      _getTextHeight: function(text) {
        const measureElement = document.createElement('div');
        measureElement.style.fontFamily = this.fontFamily;
        measureElement.style.whiteSpace = 'nowrap';
        measureElement.style.fontSize = this.fontSize + 'px';
        measureElement.style.fontWeight = this.fontWeight;
        measureElement.style.fontStyle = this.fontStyle;
        measureElement.style.position = 'absolute';
        measureElement.style.visibility = 'hidden';
        measureElement.textContent = text;

        document.body.appendChild(measureElement);
        const height = measureElement.offsetHeight;
        document.body.removeChild(measureElement);

        return height;
      },

      /**
       * Calculate rotation for center alignment
       */
      _calculateCenterAlignment: function(ctx, text, startAngle, diameter, textHeight, kerning,
  clockwise) {
        for (let i = 0; i < text.length; i++) {
          const charWidth = ctx.measureText(text[i]).width;
          const isLastChar = (i === text.length - 1);
          const spacing = isLastChar ? 0 : kerning;
          startAngle += ((charWidth + spacing) / (diameter / 2 - textHeight)) / 2 * -clockwise;
        }
        return startAngle;
      },

      /**
       * Draw all characters on the circular path
       */
      _drawCharacters: function(ctx, text, diameter, textHeight, kerning, fill, inwardFacing,
  clockwise) {
        for (let i = 0; i < text.length; i++) {
          const char = text[i];
          const charWidth = ctx.measureText(char).width;
          const radius = diameter / 2 - textHeight;
          const yPosition = (inwardFacing ? 1 : -1) * (0 - diameter / 2 + textHeight / 2);

          // Rotate to character position
          ctx.rotate((charWidth / 2) / radius * clockwise);

          // Draw stroke if specified
          if (this.strokeStyle && this.strokeWidth) {
            ctx.strokeStyle = this.strokeStyle;
            ctx.lineWidth = this.strokeWidth;
            ctx.miterLimit = 2;
            ctx.strokeText(char, 0, yPosition);
          }

          // Draw character
          ctx.fillStyle = fill;
          ctx.fillText(char, 0, yPosition);

          // Rotate to next position
          ctx.rotate((charWidth / 2 + kerning) / radius * clockwise);
        }
      },

      /**
       * Handle property setting with special cases for scaling
       */
      _set: function(key, value) {
        switch(key) {
          case 'scaleX':
            this.fontSize *= value;
            this.diameter *= value;
            this.width *= value;
            this.scaleX = 1;
            if (this.width < 1) this.width = 1;
            break;

          case 'scaleY':
            this.height *= value;
            this.scaleY = 1;
            if (this.height < 1) this.height = 1;
            break;

          default:
            this.callSuper('_set', key, value);
            break;
        }
      },

      /**
       * Render the curved text on canvas
       */
      _render: function(ctx) {
        const canvas = this.getCircularText();
        this._trimCanvas(canvas);

        this.set('width', canvas.width);
        this.set('height', canvas.height);

        ctx.drawImage(canvas, -this.width / 2, -this.height / 2, this.width, this.height);
        this.setCoords();
      },

      /**
       * Convert object to JSON representation
       */
      toObject: function(propertiesToInclude) {
        const properties = [
          'text', 'diameter', 'kerning', 'flipped', 'fill',
          'fontFamily', 'fontSize', 'fontWeight', 'fontStyle',
          'strokeStyle', 'strokeWidth'
        ];
        return this.callSuper('toObject', properties.concat(propertiesToInclude || []));
      }
    });

    /**
     * Create CurvedText from object data
     */
    fabric.CurvedText.fromObject = function(object, callback, forceAsync) {
      return fabric.Object._fromObject('CurvedText', object, callback, forceAsync, 'curved-text');
    };

  })(typeof fabric !== 'undefined' ? fabric : require('fabric').fabric);

// Application Code - Vanilla JavaScript
class CurvedTextApp {
  constructor() {
    this.config = {
      defaultFont: 'Arial',
      defaultText: 'Winner example',
      defaultDiameter: 360,
      defaultFontSize: 32,
      defaultPosition: { left: 50, top: 50 },
      defaultFill: 'black'
    };

    this.useCurvedText = false;

    this.elements = {
      text: null,
      fontSize: null,
      diameter: null,
      kerning: null,
      flip: null,
      addToCanvas: null
    };

    this.fcanvas = null;
    this.canvas2 = null;
  }

  /**
   * Initialize the application
   */
  init() {
    document.addEventListener('turbo:load', () => {
      if (document.getElementById('addToCanvas')) {
        this.initializeElements();
        this.initializeCanvases();
        this.createInitialText();
        this.bindEvents();
        this.logCanvasJSON();
      };
    });
  }

  /**
   * Cache DOM elements
   */
  initializeElements() {
    this.elements = {
      text: document.getElementById('text'),
      fontSize: document.getElementById('fontSize'),
      diameter: document.getElementById('diameter'),
      kerning: document.getElementById('kerning'),
      flip: document.getElementById('flip'),
      addToCanvas: document.getElementById('addToCanvas'),
      deleteButton: document.getElementById('deleteButton')
    };
  }

  /**
   * Initialize fabric canvases
   */
  initializeCanvases() {
    fabric.Object.prototype.objectCaching = false;
    this.fcanvas = new fabric.Canvas('canvas1');
    this.canvas2 = new fabric.Canvas('canvas2');
  }

  /**
   * Create initial curved text object
   */
  createInitialText() {
    // const initialCurvedText = new fabric.CurvedText(this.config.defaultText, {
    //   diameter: this.config.defaultDiameter,
    //
    // });

    const initialText = new fabric.Text(this.config.defaultText, {
      fontSize: this.config.defaultFontSize,
      fontFamily: this.config.defaultFont,
      left: this.config.defaultPosition.left,
      top: this.config.defaultPosition.top,
      fill: this.config.defaultFill
    });

    this.fcanvas.add(initialText);
  }

  /**
   * Get form values
   * @returns {Object} Form values
   */
  getFormValues() {
    return {
      text: this.elements.text?.value || '',
      fontSize: parseInt(this.elements.fontSize?.value || this.config.defaultFontSize, 10),
      diameter: parseInt(this.elements.diameter?.value || this.config.defaultDiameter, 10),
      kerning: parseInt(this.elements.kerning?.value || 0, 10),
      flipped: this.elements.flip?.checked || false
    };
  }

  /**
   * Update or create curved text object
   */
  editObject(shouldCreateNew = false) {
    const values = this.getFormValues();
    const activeObject = this.fcanvas.getActiveObject();

    if (activeObject) {
      if (values.diameter === 100) {
        if (activeObject.type === 'curved-text') {
          this.convertToStraightText(activeObject, values.diameter);
          return;
        }
      } else if (activeObject.type === 'text') {
        this.convertToCurvedText(activeObject, values.diameter);
        return;
      }

      this.updateExistingObject(activeObject, values);
    } else if (shouldCreateNew) {
      this.createaddToCanvas(values);
    }
  }

  /**
   * Update existing curved text object
   * @param {fabric.CurvedText} object - Object to update
   * @param {Object} values - New values
   */
  updateExistingObject(object, values) {
    if (object.type == 'curved-text') {
      object.set({
        text: values.text,
        diameter: values.diameter,
        fontSize: values.fontSize,
        fontFamily: this.config.defaultFont,
        kerning: values.kerning,
        flipped: values.flipped
      });
    } else if (object.type == 'text') {
      object.set({
        text: values.text,
        diameter: values.diameter,
        fontSize: values.fontSize,
        fontFamily: this.config.defaultFont,
        charSpacing: values.kerning * 50,
        flipX: values.flipped
      });
    }

    this.fcanvas.renderAll();
  }

  convertToCurvedText(textObject, diameter) {
    const properties = {
      text: textObject.text,
      fontSize: textObject.fontSize,
      fontFamily: textObject.fontFamily,
      left: textObject.left,
      top: textObject.top,
      fill: textObject.fill,
      diameter: diameter
    };
    this.fcanvas.remove(textObject);
    const curvedTextObject = new fabric.CurvedText(properties.text, {
      diameter: properties.diameter,
      fontSize: properties.fontSize,
      fontFamily: properties.fontFamily,
      left: properties.left,
      top: properties.top,
      fill: properties.fill
    });
    this.fcanvas.add(curvedTextObject);
    this.fcanvas.setActiveObject(curvedTextObject);
    this.fcanvas.renderAll();

    this.useCurvedText = true;
  }

  convertToStraightText(textObject, diameter) {
    const properties = {
      text: textObject.text,
      fontSize: textObject.fontSize,
      fontFamily: textObject.fontFamily,
      left: textObject.left,
      top: textObject.top,
      fill: textObject.fill,
      diameter: diameter
    };
    this.fcanvas.remove(textObject);
    const straightTextObject = new fabric.Text(properties.text, {
      fontSize: properties.fontSize,
      fontFamily: properties.fontFamily,
      left: properties.left,
      top: properties.top,
      fill: properties.fill
    });
    this.fcanvas.add(straightTextObject);
    this.fcanvas.setActiveObject(straightTextObject);
    this.fcanvas.renderAll();

    this.useCurvedText = false;
  }

  /**
   * Create new curved text object
   * @param {Object} values - Object values
   */
  createaddToCanvas(values) {
    // const addToCanvas = new fabric.CurvedText(values.text, {
      // diameter: values.diameter,
      // fontSize: values.fontSize,
      // fontFamily: this.config.defaultFont,
      // kerning: values.kerning,
      // flipped: values.flipped,
      // left: this.config.defaultPosition.left,
      // top: this.config.defaultPosition.top
    // });
    const straightText = new fabric.Text(values.text, {
      fontSize: this.config.defaultFontSize,
      fontFamily: this.config.defaultFont,
      left: this.config.defaultPosition.left,
      top: this.config.defaultPosition.top,
      fill: this.config.defaultFill
    })
    this.fcanvas.add(straightText);
    this.elements.diameter.value = 100;
  }

  /**
   * Update form controls based on selected object
   * @param {Event} event - Fabric.js event
   */
  updateControls(event) {
    const object = event.target;

    if (object.type !== 'curved-text') return;

    if (this.elements.diameter) this.elements.diameter.value = object.diameter;
    if (this.elements.text) this.elements.text.value = object.text;
    if (this.elements.fontSize) this.elements.fontSize.value = object.fontSize;
    if (this.elements.kerning) this.elements.kerning.value = object.kerning;
    if (this.elements.flip) this.elements.flip.checked = object.flipped;
  }

  /**
   * Bind event listeners
   */
  bindEvents() {
    // Canvas events
    this.fcanvas.on('object:selected', (event) => this.updateControls(event));
    this.fcanvas.on('selection:updated', (event) => this.updateControls(event));

    // Form control events - these only update existing objects
    const inputElements = [this.elements.diameter, this.elements.fontSize, this.elements.kerning];
    inputElements.forEach(element => {
      if (element) {
        element.addEventListener('input', () => this.editObject(false));
      }
    });

    if (this.elements.text) {
      this.elements.text.addEventListener('keyup', () => this.editObject(false));
    }

    if (this.elements.flip) {
      this.elements.flip.addEventListener('click', () => this.editObject(false));
    }

    // Only the "Add to canvas" button creates new objects
    if (this.elements.addToCanvas) {
      this.elements.addToCanvas.addEventListener('click', () => this.editObject(true));
    }

    if (this.elements.deleteButton) {
      this.elements.deleteButton.addEventListener('click', () => this.deleteItem());
    }
  }

  /**
   * Log canvas JSON for debugging
   */
  logCanvasJSON() {
    const canvasJSON = this.fcanvas.toJSON();
    console.log('Canvas JSON:', canvasJSON);
  }

  /**
   * Delete curved text item
   * @param {fabric.CurvedText} curvedText - Text object to delete
   */
  deleteItem() {
    const activeObject = this.fcanvas.getActiveObject();
    if (activeObject) {
      this.fcanvas.remove(activeObject);
      this.fcanvas.renderAll();
    }
  }

  /**
   * Get active curved text object
   * @returns {fabric.CurvedText|null} Active object if it's curved text
   */
  getActiveCurvedText() {
    const activeObject = this.fcanvas.getActiveObject();
    return activeObject && activeObject.type === 'curved-text' ? activeObject : null;
  }

  /**
   * Clear all objects from canvas
   */
  clearCanvas() {
    this.fcanvas.clear();
  }

  /**
   * Export canvas as JSON
   * @returns {string} Canvas JSON
   */
  exportCanvasJSON() {
    return JSON.stringify(this.fcanvas.toJSON());
  }

  /**
   * Load canvas from JSON
   * @param {string} jsonString - Canvas JSON string
   */
  loadCanvasFromJSON(jsonString) {
    try {
      this.fcanvas.loadFromJSON(jsonString, () => {
        this.fcanvas.renderAll();
      });
    } catch (error) {
      console.error('Error loading canvas from JSON:', error);
    }
  }
}

// Initialize application
const curvedTextApp = new CurvedTextApp();
curvedTextApp.init();
