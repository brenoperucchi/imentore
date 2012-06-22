(function() {
  var DOM, INITIAL_SAVINGS_AVG, INITIAL_VEHICLE_COUNT, NumberHelper, PriceTier, PricingModel, pricingModel, recordInKM, setupRoiPopoverTwipsy, setupSliderTwipsy, setupVehicleCountSlider, updateAnnualSavings, updatePrice, updateROI, updateVehicleCount, updateVehicleSavings;

  INITIAL_VEHICLE_COUNT = 10;

  INITIAL_SAVINGS_AVG = 50000;

  PriceTier = (function() {

    function PriceTier(start, end, priceInCents) {
      this.start = start;
      this.end = end;
      this.priceInCents = priceInCents;
    }

    PriceTier.prototype.calculateMonthlyPrice = function(vehicleCount) {
      if (vehicleCount >= this.start && vehicleCount <= this.end) {
        return this.priceInCents;
      } else {
        return 0;
      }
    };

    return PriceTier;

  })();

  PricingModel = (function() {
    var priceTiers;

    priceTiers = [];

    function PricingModel() {
      priceTiers = [new PriceTier(1, 10, 0), new PriceTier(11, 25, 1900), new PriceTier(26, 50, 3900), new PriceTier(51, 100, 7900), new PriceTier(101, 250, 14900)];
    }

    PricingModel.prototype.calculateMonthlyPrice = function(vehicleCount) {
      var price, pt, _i, _len;
      price = 0;
      for (_i = 0, _len = priceTiers.length; _i < _len; _i++) {
        pt = priceTiers[_i];
        price += pt.calculateMonthlyPrice(vehicleCount);
      }
      return price;
    };

    PricingModel.prototype.calculateAnnualPrice = function(vehicleCount) {
      return this.calculateMonthlyPrice(vehicleCount) * 12;
    };

    PricingModel.prototype.calculateROI = function(vehicleCount, annualSavingsPerVehicle) {
      return this.calculateAnnualSavings(vehicleCount, annualSavingsPerVehicle) - this.calculateAnnualPrice(vehicleCount);
    };

    PricingModel.prototype.calculateAnnualSavings = function(vehicleCount, annualSavingsPerVehicle) {
      return annualSavingsPerVehicle * vehicleCount;
    };

    return PricingModel;

  })();

  NumberHelper = (function() {

    function NumberHelper() {}

    NumberHelper.toDollars = function(valueInCents) {
      return parseFloat(valueInCents / 100).toFixed(2);
    };

    NumberHelper.toUSD = function(valueInCents) {
      return "$" + (this.addCommas(this.toDollars(valueInCents)));
    };

    NumberHelper.addCommas = function(nStr) {
      var rgx, x, x1, x2;
      nStr += '';
      x = nStr.split('.');
      x1 = x[0];
      x2 = x.length > 1 ? '.' + x[1] : '';
      rgx = /(\d+)(\d{3})/;
      while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
      }
      return x1 + x2;
    };

    return NumberHelper;

  })();

  DOM = (function() {

    function DOM() {}

    DOM.getVehicleCount = function() {
      return $('#vehicle-count-roi-slider').slider('value');
    };

    DOM.getAnnualSavings = function() {
      return $('#vehicle-savings-slider').slider('value');
    };

    return DOM;

  })();

  pricingModel = new PricingModel();

  updatePrice = function(vehicleCount) {
    var price;
    price = pricingModel.calculateMonthlyPrice(vehicleCount);
    $('#price').html(NumberHelper.toUSD(price));
    return $('#annual-price').html(NumberHelper.toUSD(price * 12));
  };

  updateVehicleCount = function(vehicleCount) {
    var label;
    label = vehicleCount === 1 ? 'vehicle' : 'vehicles';
    return $('#vehicle-count').html("" + vehicleCount + " " + label);
  };

  updateVehicleSavings = function(valueInCents) {
    return $('#vehicle-savings').html(NumberHelper.toUSD(valueInCents));
  };

  updateAnnualSavings = function() {
    var savings;
    savings = pricingModel.calculateAnnualSavings(DOM.getVehicleCount(), DOM.getAnnualSavings());
    return $('#annual-savings').html(NumberHelper.toUSD(savings));
  };

  updateROI = function() {
    var roi;
    roi = pricingModel.calculateROI(DOM.getVehicleCount(), DOM.getAnnualSavings());
    return $('.roi-result').html(NumberHelper.toUSD(roi));
  };

  setupVehicleCountSlider = function(selector, min, max, initialValue) {
    return $(selector).slider({
      min: min,
      max: max,
      value: initialValue,
      create: function(event, ui) {
        return setupSliderTwipsy(selector);
      },
      slide: function(event, ui) {
        return updateVehicleCount(ui.value);
      },
      change: function(event, ui) {
        updatePrice(ui.value);
        updateAnnualSavings();
        updateROI();
        return recordInKM();
      }
    });
  };

  setupSliderTwipsy = function(selector) {
    var el;
    el = $("" + selector + " a.ui-slider-handle");
    el.twipsy({
      offset: 2,
      placement: 'below',
      trigger: 'manual',
      fallback: 'Drag to change'
    }).twipsy('show');
    return el.mouseover(function() {
      return el.twipsy('hide');
    });
  };

  setupRoiPopoverTwipsy = function() {
    var el;
    el = $("#roi-popover");
    el.twipsy({
      placement: 'below',
      trigger: 'manual',
      fallback: 'Hover for more info'
    }).twipsy('show');
    return el.mouseover(function() {
      return el.twipsy('hide');
    });
  };

  window._kmq = window._kmq || [];

  recordInKM = function() {
    return _kmq.push([
      'record', 'Changed ROI Calculator', {
        'Vehicle Count': DOM.getVehicleCount(),
        'Savings Per Vehicle': NumberHelper.toDollars(DOM.getAnnualSavings())
      }
    ]);
  };

  $(function() {
    setupVehicleCountSlider('#vehicle-count-roi-slider', 1, 250, INITIAL_VEHICLE_COUNT);
    setupVehicleCountSlider('#vehicle-count-pricing-slider', 1, 250, INITIAL_VEHICLE_COUNT);
    $('#vehicle-savings-slider').slider({
      min: 10000,
      max: 150000,
      step: 2500,
      value: INITIAL_SAVINGS_AVG,
      slide: function(event, ui) {
        return updateVehicleSavings(ui.value);
      },
      change: function(event, ui) {
        updateAnnualSavings();
        updateROI();
        return recordInKM();
      }
    });
    $('#roi-popover').popover({
      placement: 'above',
      offset: 20,
      html: true
    });
    updateVehicleCount(INITIAL_VEHICLE_COUNT);
    updatePrice(INITIAL_VEHICLE_COUNT);
    updateVehicleSavings(INITIAL_SAVINGS_AVG);
    updateAnnualSavings();
    updateROI();
    return setupRoiPopoverTwipsy();
  });

}).call(this);
