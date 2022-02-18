//
//  NSXMLParser+Block.m
//  CEd Mobile
//
//  Created by Kurt Heiligmann on 1/8/13.
//  Copyright (c) 2013 McGraw-Hill. All rights reserved.
//

#import "NSXMLParser+Block.h"
#import <objc/runtime.h>

static char START_IDENTIFIER;
static char FOUND_CHARACTERS_IDENTIFIER;
static char END_IDENTIFIER;

@implementation NSXMLParser (Block)

@dynamic startElementBlock;
@dynamic foundCharactersBlock;
@dynamic endElementBlock;

+ (NSXMLParser *)parserWithData:(NSData *)data didStartElement:(StartElementBlock)startedElement didFindCharacters:(FoundCharactersBlock)foundCharacters didEndElement:(EndElementBlock)endedElement {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    parser.delegate = [NSXMLParser self];
    
    [parser setStartElementBlock:startedElement];
    [parser setFoundCharactersBlock:foundCharacters];
    [parser setEndElementBlock:endedElement];
    
    return parser;
}

+ (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    parser.startElementBlock(parser, elementName, namespaceURI, qualifiedName, attributeDict);
}

+ (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    parser.foundCharactersBlock(string);
}

+ (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    parser.endElementBlock(parser, elementName, namespaceURI, qName);
}

- (void)setStartElementBlock:(StartElementBlock)startElementBlock {
    objc_setAssociatedObject(self, &START_IDENTIFIER, startElementBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (StartElementBlock)startElementBlock {
    return objc_getAssociatedObject(self, &START_IDENTIFIER);
}

- (void)setFoundCharactersBlock:(FoundCharactersBlock)foundCharactersBlock {
    objc_setAssociatedObject(self, &FOUND_CHARACTERS_IDENTIFIER, foundCharactersBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (FoundCharactersBlock)foundCharactersBlock {
    return objc_getAssociatedObject(self, &FOUND_CHARACTERS_IDENTIFIER);
}

- (void)setEndElementBlock:(EndElementBlock)endElementBlock {
    objc_setAssociatedObject(self, &END_IDENTIFIER, endElementBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (EndElementBlock)endElementBlock {
    return objc_getAssociatedObject(self, &END_IDENTIFIER);
}

@end
