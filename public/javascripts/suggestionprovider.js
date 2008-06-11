
/**
 * Provides suggestions for state names (USA).
 * @class
 * @scope public
 */
function SuggestionsProvider(aNameValues) {
    this.nameValues = aNameValues;
}

/**
 * Request suggestions for the given autosuggest control. 
 * @scope protected
 * @param oAutoSuggestControl The autosuggest control to provide suggestions for.
 */
SuggestionsProvider.prototype.requestSuggestions = function (oAutoSuggestControl /*:AutoSuggestControl*/) {
    var aSuggestions = [];
    var sTextboxValue = oAutoSuggestControl.textbox.value;
    
    if (sTextboxValue.length > 0){
    
        //search for matching names
        for (var i=0; i < this.nameValues.length; i++) { 
            if (this.nameValues[i].indexOf(sTextboxValue) == 0) {
                aSuggestions.push(this.nameValues[i]);
            } 
        }
    }

    //provide suggestions to the control
    oAutoSuggestControl.autosuggest(aSuggestions);
};
