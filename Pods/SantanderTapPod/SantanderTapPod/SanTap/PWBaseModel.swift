//
//  PWBaseModel.swift
//  SantanderTap2.0
//
//  Created by MacPro on 26/05/20.
//  Copyright © 2020 jvmv. All rights reserved.
//

import UIKit

class PWBaseModel: NSObject {

    // MARK: Public methods
    
    func dictionaryRepresentation()->Dictionary<String,AnyObject>
    {
        return self.getAttributeMapping()
    }
    
    func createWithDictionary(dictionary:Dictionary<String,AnyObject>) -> PWBaseModel
    {
        return PWBaseModel()
    }
    
    func getObjectsFromFile(_ fileName:String) -> [PWBaseModel]
    {
        do{
            let filePath = Bundle.main.url(forResource: fileName, withExtension: "json")
            let data: Data? = try Data(contentsOf: filePath!, options: Data.ReadingOptions.uncached)
            let parseData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
            if(parseData is Dictionary<String,AnyObject>)
            {
                
                return [self.createWithDictionary(dictionary: parseData as! Dictionary<String,AnyObject>)]
            }
            else
            {
                let arr = parseData as! [Dictionary<String,AnyObject>]
                return self.createObjectsFromArray(array: arr)
            }
        }
        catch
        {
            return [PWBaseModel]()
        }
    }
    
    func createObjectsFromArray(array:[Dictionary<String,AnyObject>]) -> [PWBaseModel]
    {
        var ret = [PWBaseModel]()
        for dicc in array
        {
            ret.append(self.createWithDictionary(dictionary: dicc))
        }
        return ret
    }
    
    func getAttributeMapping()->Dictionary<String,AnyObject>
    {
        var dict = [String:AnyObject]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value as AnyObject?
            }
        }
        return dict
    }
    
    func parseDateFromString(str:String,format:String)->Date
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: str)!
    }
}
