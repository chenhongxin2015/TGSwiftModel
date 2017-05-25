//
//  TGItemExtesion.swift
//  TJSwift
//
//  Created by 蔡国龙 on 2017/5/10.
//  Copyright © 2017年 TG. All rights reserved.
//

import Foundation
import UIKit

//protocol NSObject {
//    
//}
//
//protocol TGObjectProtocol : NSObjectProtocol {
//    func propertyObjectClassInAarry() -> Void
//}
extension NSObject
{
    
    
    
    class func tg_setValuesForKeys(dic : NSDictionary?) -> NSObject? {
        
        //创建对象
        let object = self.init()
        
//        var count : UInt32 = 0
        
        var outCount : UInt32 = 0
        //获取属性列表
        let propers : UnsafeMutablePointer<objc_property_t?>! = class_copyPropertyList(self, &outCount)
        if outCount < 1 {
            return object
        }
        for i in 0...(outCount - 1) {
            let aPro : objc_property_t = (propers?[Int(i)]!)!
            //获取属性名称
            let nameApro = property_getName(aPro)
            let proName : String = String.init(utf8String: nameApro!)!
//            nameApro.des
            print(proName)
            //获取属性类型
            let proTypeName : String = String.init(utf8String:  property_getAttributes(aPro))!
            let arrayPropers = proTypeName.components(separatedBy: ",").first
            var proType = arrayPropers?.replacingOccurrences(of: "T@\"", with: "")
            proType = proType?.replacingOccurrences(of: "_TtC7TJSwift", with: "")
            proType = proType?.replacingOccurrences(of: "\"", with: "")
            
//            aPro.d
            
            
            //MARK:打印
//            print(proType!)
            if let value = dic?.value(forKey: proName) {
                // 将value 为字典类型的数据 根据用户声明的 类型转换为模型 对象
                if (proType?.hasPrefix("NS"))! == false && proType != nil{//属于foundation类
                    //获取声明类型对应的字符串
                    while let i = proType?.characters.index(where: { $0 >= "0" && $0 <= "9"
                    }) {
                        proType?.remove(at: i)
                        print(proType!)
                    }
                    //   根据类型字符串获取 对应的类型
                    if let clsType = self.getClassType(classStr: proType!) {
                        //通过Class创建对象
                        let  Subobject = clsType.tg_setValuesForKeys(dic: value as? NSDictionary)
                        object.setValue(Subobject, forKey: proName)
                    }else
                    {
                        print("类型匹配 有问题")
                    }

                }else
                {
                    
                    if  (proType?.hasPrefix("NSArray"))!{
                        //数组属性 并且已经声明了数组类型
                        if let clsType = self.propertyObjectClassInAarry(properName: proName) {
                            var arrayObjects = Array<Any>()
                            
                            let arrayValue = value as! NSArray
                            for (_ ,value) in arrayValue.enumerated() {
                                let subObject = clsType.tg_setValuesForKeys(dic: (value as! NSDictionary))
                                arrayObjects.append(subObject as Any)
//                                arrayObjects.append((subObject as? AnyClass)!)
                            }
                            object.setValue(arrayObjects, forKey: proName)
                            break
                        }
                    }
                    //其他情况
                    object.setValue(value, forKey: proName)
                    
                }
                
            }
        }
        return object
    }
    
    
//    class func objctClassInArray() -> Dictionary<String, String>
    
    //MARK:根据数组属性名 给出对应的 类型 (需要用户根据实际情况给出)
    class func propertyObjectClassInAarry(properName : String) -> AnyClass? {
        //如果返回不为空
        if let properTypeName =  self.propertyClassInAarry()?[properName] {
            return self.getClassType(classStr:properTypeName)
        }
        return nil
    }
    
    
    
    //MARK: 根据字符串 名称返回类 类型
    class func getClassType(classStr : String) -> AnyClass? {
        
        
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return nil
        }
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + classStr)
        guard let clsType = cls as? NSObject.Type else {
            print("类型不匹配")
            return nil
        }
        
        return clsType
    }
    
    
    
    
    
    
    //声明接口 告诉array声明的类 类型
    class func propertyClassInAarry() -> Dictionary<String, String>? {
        
        return nil
    }
    
    
}








//
////获取成员变量数组
//let ivarList = class_copyIvarList(self, &count)
//
//
////遍历成员变量
//for i in 0...(count - 1) {
//    //获取成员变量
//    let ivar : Ivar? = ivarList?[Int(i)]
//    
//    //获取成员变量名字
//    let charIvarName = ivar_getName(ivar)
//    let ivarName = String.init(utf8String: charIvarName!)
//    print("ivarName " + ivarName!)
//    
//    //获取成员变量的类型
//    let charIvarType = ivar_getTypeEncoding(ivar) //指针
//    //            print(ivar?.debugDescription as Any)
//    
//    print(charIvarType as Any)
//    let ivarType = NSString.init(utf8String: charIvarType!)
//    //            let ivarTypeStr = String.ini
//    print("ivarType" + String.init(describing: ivarType))
//    
//    
//    
//    
//}
//

