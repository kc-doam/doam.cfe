﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается перед открытием формы нового письма.
// Открытие формы может быть отменено изменением параметра СтандартнаяОбработка.
//
// Параметры:
//  ПараметрыОтправки    - Структура - см. описание в РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо;
//  ОбработчикЗавершения - ОписаниеОповещения - описание процедуры, которая будет вызвана после завершения
//                                              отправки письма.
//  СтандартнаяОбработка - Булево - признак продолжения открытия формы нового письма после выхода из этой
//                                  процедуры. Если установить Ложь, форма письма открыта не будет.
Процедура ПередОткрытиемФормыОтправкиПисьма(ПараметрыОтправки, ОбработчикЗавершения, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Позволяет переопределить обновление токена
//
// Параметры:
//
// АдресПолный -Строка, возвращаемый параметр
// СерверВходящейПочты -Строка
// Oauth_redirection_uri -Строка 
// OauthАвторизацияКлиент -Строка  
//
// Возвращает Истина, если переопределило процедуру
Функция СформироватьАдресДляАвторизацииOAuth(
	АдресПолный, 
	СерверВходящейПочты,
	OauthАвторизацияКлиент, 
	Oauth_redirection_uri) Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти