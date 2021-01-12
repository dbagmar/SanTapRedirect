//
//  KeyboardParentViewController+Autocomplete.swift
//

//import KeyboardKit
import UIKit

extension KeyboardParentViewController {
    
    func requestAutocompleteSuggestions() {
        let word = textDocumentProxy.currentWord ?? ""
        autocompleteProvider.autocompleteSuggestions(for: word) { [weak self] in
            self?.handleAutocompleteSuggestionsResult($0)
        }
    }
    
    func resetAutocompleteSuggestions() {
        autocompleteToolbar.reset()
    }
    
    func amountToolbarUpdate() {
        if(amountPagar=="0.00"){
            amountToolbar.update(with: ["$0.00"])
        }else{
            amountToolbar.update(with: ["$"+amountPagar])
        }
    }
}

private extension KeyboardParentViewController {
    
    func handleAutocompleteSuggestionsResult(_ result: AutocompleteResult) {
        switch result {
        case .failure(let error): printLog(error.localizedDescription)
        case .success(let result): autocompleteToolbar.update(with: result)
        }
    }
}
