//
//  Validation.swift
//  Caloriender
//
//  Created by Uğur Güçer on 7.05.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import Foundation


class ValidationError: Error{
    
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
    
}

enum ValidationType{
    case nameOrSurname
    case username
    case email
    case height
    case weight
    case age
    case password
}

protocol ValidationConvertible {
    func validate(_ value: String) throws -> String
}

enum ValidationFactory {
    static func validateFor(type: ValidationType) -> ValidationConvertible {
        switch type {
        case .nameOrSurname: return NameOrSurnameValidator()
        case .username: return UsernameValidator()
        case .email: return EMailValidator()
        case .height: return HeightValidator()
        case .weight: return WeightValidator()
        case .age: return AgeValidator()
        case .password: return PasswordValidator()
        }
    }
}

struct NameOrSurnameValidator: ValidationConvertible {
    func validate(_ value: String) throws -> String {
        guard value.count > 1 && value.count < 51 else {throw ValidationError("Ad ve Soyad alanları en az 2 en fazla 50 karakter olmalıdır.")}
    
        return value
    }
}

struct UsernameValidator: ValidationConvertible {
    func validate(_ value: String) throws -> String {
        let turkishCharacterList = ["ç", "Ç", "ğ", "Ğ", "ü", "Ü", "Ö", "ö", "ı", "İ", "ş", "Ş"]
        guard !turkishCharacterList.contains(where: {value.contains($0)}) else {throw ValidationError("Kullanıcı adı türkçe karakter içermemeli.")}
        guard value.count > 4 &&  value.count < 31 else {throw ValidationError("Kullanıcı Adı en az 5 ve en fazla 30 karakter olmalı.")}
        
        return value
    }
}

struct EMailValidator: ValidationConvertible {
    func validate(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$").firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Geçersiz e-mail adresi girdiniz.")
            }
        } catch {
            throw ValidationError("Geçersiz e-mail adresi girdiniz.")
        }
        return value
    }
}

struct HeightValidator: ValidationConvertible {
    func validate(_ value: String) throws -> String {
        guard let heightvalue = Int(value) else {throw ValidationError("Boy alanı nümerik olmalı")}
        guard heightvalue > 99 && heightvalue < 251 else { throw ValidationError("Boy değeri 100 ve 250 değer aralığında olmalıdır.")}
        
        return value
    }
}

struct WeightValidator: ValidationConvertible {
    func validate(_ value: String) throws -> String {
        guard let weightvalue = Int(value) else {throw ValidationError("Ağırlık alanı nümerik olmalı")}
        guard weightvalue > 24 else { throw ValidationError("Ağırlık değeri 25'e eşit ve 25ten büyük olmalıdır")}
        
        return value
    }
}

struct AgeValidator: ValidationConvertible {
    func validate(_ value: String) throws -> String {
        guard let agevalue = Int(value) else {throw ValidationError("Yaş alanı nümerik olmalı")}
        guard agevalue > 12 else { throw ValidationError("Yaş değeri 13'e eşit ve 13'ten büyük olmalıdır")}
        
        return value
    }
}

struct PasswordValidator: ValidationConvertible {
    func validate(_ value: String) throws -> String {
        guard value.count > 7 &&  value.count < 38 else {throw ValidationError("Şifre alanı en az 8 en fazla 25 karakterden oluşmalıdır.")}
        
        return value
    }
}

