//
// Created by Allison Husain on 4/27/18.
//

#ifndef HTMLTOATTR_FORMAT_H
#define HTMLTOATTR_FORMAT_H
struct t_tag {
    unsigned int startPosition;
    unsigned int endPosition;
    char *tag;
    
    size_t tableDataLength;
    char *tableData;
};
#endif //HTMLTOATTR_FORMAT_H
