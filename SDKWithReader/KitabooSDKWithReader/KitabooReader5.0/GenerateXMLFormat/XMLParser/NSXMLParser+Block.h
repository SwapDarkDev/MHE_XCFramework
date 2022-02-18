//
//  NSXMLParser+Block.h
//  CEd Mobile
//
//  Created by Kurt Heiligmann on 1/8/13.
//  Copyright (c) 2013 McGraw-Hill. All rights reserved.
//

typedef void (^StartElementBlock)(NSXMLParser *parser, NSString *elementName, NSString *namespaceURI, NSString *qualifiedName, NSDictionary *attributeDict);
typedef void (^FoundCharactersBlock)(NSString *foundCharacters);
typedef void (^EndElementBlock)(NSXMLParser *parser, NSString *elementName, NSString *namespaceURI, NSString *qualifiedName);


@interface NSXMLParser (Block) <NSXMLParserDelegate>

+ (NSXMLParser *)parserWithData:(NSData *)data
                didStartElement:(StartElementBlock)startedElement
              didFindCharacters:(FoundCharactersBlock)foundCharacters
                  didEndElement:(EndElementBlock)endedElement;

@property (nonatomic, copy) StartElementBlock startElementBlock;
@property (nonatomic, copy) FoundCharactersBlock foundCharactersBlock;
@property (nonatomic, copy) EndElementBlock endElementBlock;

@end
