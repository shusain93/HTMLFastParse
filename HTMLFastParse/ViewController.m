//
//  ViewController.m
//  HTMLFastParse
//
//  Created by Salman Husain on 4/27/18.
//  Copyright © 2018 CarbonDev. All rights reserved.
//

#import "ViewController.h"
#import "HTML_Parser.h"
#include "C_HTML_Parser.h"
#include "t_tag.h"
#include "t_format.h"
#import "FormatToAttributedString.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	/*char* input = [@"Plain <strong>bold <em>bold and italic</em>. </strong><p><a href=\"https://test.com\">Wikitest</a></p>" UTF8String];
	//char* input = [@"<strong>BOLD</strong>" UTF8String];
	unsigned long inputLength = strlen(input);
	
	char displayTextBuffer[inputLength * sizeof(char)];
	char* displayText = &displayTextBuffer[0];
	struct t_tag tokenBuffer[inputLength * sizeof(struct t_tag)];
	struct t_tag* tokens = &tokenBuffer[0];
	
	struct t_format finalTokenBuffer[inputLength * sizeof(struct t_format)];
	struct t_format* finalTokens = &finalTokenBuffer[0];
	
	int numberOfTags = -1;
	tokenizeHTML(input, inputLength, displayText,tokens,&numberOfTags);
	int numberOfSimplifiedTags = -1;
	makeAttributesLinear(tokens, (int)numberOfTags, finalTokens,&numberOfSimplifiedTags,(int)strlen(displayText));
	
	for (int i = 0; i < numberOfSimplifiedTags; i++) {
		char* link = finalTokens[i].linkURL;
		free(link);
	}
	
	printf("%s\n",displayText);*/
	
	NSString * other = @"\n\n\n<div class=\"md\"><p>Inline <code>Test code</code> outside</p>\n\n<pre><code>Code Block\nwhew still code\n</code></pre>\n\n<p>Plain</p>\n\n<blockquote>\n<p>Quote level 1</p>\n\n<blockquote>\n<p>Quote level 2</p>\n\n<blockquote>\n<p>Quote level3</p>\n</blockquote>\n</blockquote>\n</blockquote>\n<a href=\"https://test.com\">Wikitest</a>\nblah</div>";
	//NSString * other = @"\n\n\n<div class=\"md\"><p>Inline <code>Test code</code> outside</p>\n\n<pre><code>Code Block\nwhew still code\n</code></pre>\n\n<p>Plain</p>\n\n<a href=\"https://reddit.com/r/homelab\">Wikitest</a>\nblah</div>";
	//[self showNormal:testHTML];
	//[self doStuff:nil];
	
}

-(void)totalRuntimeForMethod:(NSString*)method block:(void(^)(void))block;
{
	extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));
	
	int iterations = 10000;
	uint64_t t = dispatch_benchmark(iterations, ^{
		@autoreleasepool {
			block();
		}
	});
	
	NSLog(@"Runtime for %i iterations (ms) %@: %f", iterations, method, t/1000000.0*iterations);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
- (IBAction)doStuff:(id)sender {
	/*HTML_Parser *parser = [[HTML_Parser alloc]init];
	 [self totalRuntimeForMethod:@"Obj-C Parser" block:^{
	 [parser parseHTML:testHTML];
	 }];*/
	
	FormatToAttributedString * formatter = [[FormatToAttributedString alloc]init];
	[self totalRuntimeForMethod:@"C Parser" block:^{
		[formatter attributedStringForHTML:testHTML];
		
	}];
	
	
	
	
	
}

-(void)showNormal:(NSString *)toShow {
	NSAttributedString * test = [[[FormatToAttributedString alloc]init]attributedStringForHTML:toShow];
	
	UITextView *textView = [[UITextView alloc]initWithFrame:self.view.frame textContainer:nil];
	[self.view addSubview:textView];
	textView.attributedText = test;
	textView.editable = false;
	[textView layoutSubviews];
}

NSString * testHTML = @"<div class=\"md\"><p><em>Note: For a full list of markdown syntax, see the <a href=\"http://daringfireball.net/projects/markdown/syntax\">official syntax guide</a>.  Also note that reddit doesn&#39;t support images, for which I am grateful, as that would most definitely be the catalyst needed to turn reddit into 4chan (</em><code>/r/circlejerk/</code><em>, which uses CSS trickery to permit some level of image posting, is a great example of the destructive power of images).</em></p>\n\n<h1>PARAGRAPHS</h1>\n\n<p>Paragraphs are delimited by a blank line.  Simply starting text on a new line won&#39;t create a new paragraph; It will remain on the same line in the final, rendered version as the previous line.  You need an extra, blank line to start a new paragraph.  This is especially important when dealing with quotes and, to a lesser degree, lists.</p>\n\n<p>You can also add non-paragraph line breaks by ending a line with two spaces.  The difference is subtle:</p>\n\n<p>Paragraph 1, Line 1<br/>\nParagraph 1, Line 2  </p>\n\n<p>Paragraph 2</p>\n\n<hr/>\n\n<h1>FONT FORMATTING</h1>\n\n<h3>Italics</h3>\n\n<p>Text can be displayed in an italic font by surrounding a word or words with either single asterisks (*) or single underscores (_).</p>\n\n<p>For example: </p>\n\n<blockquote>\n<p>This sentence includes *italic text*.</p>\n</blockquote>\n\n<p>is displayed as:</p>\n\n<blockquote>\n<p>This sentence includes <em>italic text</em>.</p>\n</blockquote>\n\n<h3>Bold</h3>\n\n<p>Text can be displayed in a bold font by surrounding a word or words with either double asterisks (*) or double underscores (_).</p>\n\n<p>For example: </p>\n\n<blockquote>\n<p>This sentence includes **bold text**.</p>\n</blockquote>\n\n<p>is displayed as:</p>\n\n<blockquote>\n<p>This sentence includes <strong>bold text</strong>.</p>\n</blockquote>\n\n<h3>Strikethrough</h3>\n\n<p>Text can be displayed in a strikethrough font by surrounding a word or words with double tildes (~~).  For example:</p>\n\n<blockquote>\n<p>This sentence includes ~ ~strikethrough text~ ~ </p>\n\n<p><em>(but with no spaces between the tildes; escape sequences [see far below] appear not to work with tildes, so I can&#39;t demonstrate the exact usage).</em></p>\n</blockquote>\n\n<p>is displayed as:</p>\n\n<blockquote>\n<p>This sentence includes <del>strikethrough text</del>.</p>\n</blockquote>\n\n<h3>Superscript</h3>\n\n<p>Text can be displayed in a superscript font by preceding it with a caret ( ^ ).  </p>\n\n<blockquote>\n<p>This sentence includes super^ script </p>\n\n<p><em>(but with no spaces after the caret; Like strikethrough, the superscript syntax doesn&#39;t play nicely with escape sequences).</em></p>\n</blockquote>\n\n<p>is displayed as:</p>\n\n<blockquote>\n<p>This sentence includes super<sup>script.</sup></p>\n</blockquote>\n\n<p>Superscripts can even be nested: just<sup>like<sup>this</sup></sup> .</p>\n\n<p>However, note that the superscript font will be reset by a space.  To get around this, you can enclose the text in the superscript with parentheses.  The parentheses won&#39;t be displayed in the comment, and everything inside of them will be superscripted, regardless of spaces:</p>\n\n<blockquote>\n<p>This sentence^ (has a superscript with multiple words)</p>\n\n<p><em>Once again, with no space after the caret.</em></p>\n</blockquote>\n\n<p>is displayed as</p>\n\n<blockquote>\n<p>This sentence<sup>has a superscript with multiple words</sup></p>\n</blockquote>\n\n<h3>Headers</h3>\n\n<p>Markdown supports 6 levels of headers (some of which don&#39;t actually display as headers in reddit):</p>\n\n<h1>Header 1</h1>\n\n<h2>Header 2</h2>\n\n<h3>Header 3</h3>\n\n<h4>Header 4</h4>\n\n<h5>Header 5</h5>\n\n<h6>Header 6</h6>\n\n<p>...which can be created in a couple of different ways.  Level 1 and 2 headers can be created by adding a line of equals signs (=) or dashes (-), respectively, underneath the header text. </p>\n\n<p>However, <em>all</em> types of headers can be created with a second method.  Simply prepend a number of hashes (#) corresponding to the header level you want, so:</p>\n\n<blockquote>\n<p># Header 1</p>\n\n<p>## Header 2</p>\n\n<p>### Header 3</p>\n\n<p>#### Header 4</p>\n\n<p>##### Header 5</p>\n\n<p>###### Header 6</p>\n</blockquote>\n\n<p>results in:</p>\n\n<blockquote>\n<h1>Header 1</h1>\n\n<h2>Header 2</h2>\n\n<h3>Header 3</h3>\n\n<h4>Header 4</h4>\n\n<h5>Header 5</h5>\n\n<h6>Header 6</h6>\n</blockquote>\n\n<p>Note: you can add hashes after the header text to balance out how the source code looks without affecting what is displayed. So:</p>\n\n<blockquote>\n<p>## Header 2 ##</p>\n</blockquote>\n\n<p>also produces:</p>\n\n<blockquote>\n<h2>Header 2</h2>\n</blockquote>\n\n<hr/>\n\n<h1>LISTS</h1>\n\n<p>Markdown supports two types of lists: ordered and unordered.</p>\n\n<h3>Unordered Lists</h3>\n\n<p>Prepend each element in the list with either a plus (+), dash (-), or asterisk (*) plus a space.  Line openers can be mixed.  So</p>\n\n<blockquote>\n<p>* Item 1</p>\n\n<p>+ Item 2</p>\n\n<p>- Item 3</p>\n</blockquote>\n\n<p>results in</p>\n\n<blockquote>\n<ul>\n<li>Item 1</li>\n<li>Item 2</li>\n<li>Item 3</li>\n</ul>\n</blockquote>\n\n<h3>Ordered Lists</h3>\n\n<p>Ordered lists work roughly the same way, but you prepend each item in the list with a number plus a period (.) plus a space.  Also, it makes no difference what numbers you use.  The ordered list will always start with the number 1, and will always increment sequentially.  So</p>\n\n<blockquote>\n<p>7. Item 1</p>\n\n<p>2. Item 2</p>\n\n<p>5. Item 3</p>\n</blockquote>\n\n<p>results in</p>\n\n<blockquote>\n<ol>\n<li>Item 1</li>\n<li>Item 2</li>\n<li>Item 3</li>\n</ol>\n</blockquote>\n\n<p>Also, you can nest lists, like so:</p>\n\n<ol>\n<li><p>Ordered list item 1</p></li>\n<li><ul>\n<li>Bullet 1 in list item 2</li>\n</ul>\n\n<ul>\n<li>Bullet 2 in list item 2</li>\n</ul></li>\n<li><p>List item 3</p></li>\n</ol>\n\n<p>Note: If your list items consist of multiple paragraphs, you can force each new paragraph to remain in the previous list item by indenting it by one tab or four spaces.  So</p>\n\n<blockquote>\n<p>* This item has multiple paragraphs.</p>\n\n<p>(<em>four spaces here</em>)This is the second paragraph</p>\n\n<p>* Item 2</p>\n</blockquote>\n\n<p>results in:</p>\n\n<blockquote>\n<ul>\n<li><p>This item has multiple paragraphs.</p>\n\n<p>This is the second paragraph</p></li>\n<li><p>Item 2</p></li>\n</ul>\n</blockquote>\n\n<p>Notice how the spaces in my source were stripped out?  What if you need to preserve formatting?  That brings us to:</p>\n\n<hr/>\n\n<h1>CODE BLOCKS AND INLINE CODE</h1>\n\n<p>Inline code is easy.  Simply surround any text with backticks (`), <strong>not to be confused with apostrophes (&#39;)</strong>.  Anything between the backticks will be rendered in a fixed-width font, and none of the formatting syntax we&#39;re exploring will be applied.  So</p>\n\n<blockquote>\n<p>Here is some <code>`</code>inline code with **formatting**<code>`</code></p>\n</blockquote>\n\n<p>is displayed as:</p>\n\n<blockquote>\n<p>Here is some <code>inline code with **formatting**</code></p>\n</blockquote>\n\n<p>Note that this is why you should use the normal apostrophe when typing out possessive nouns or contractions.  Otherwise you may end up with something like:</p>\n\n<blockquote>\n<p>I couldn<code>t believe that he didn</code>t know that!</p>\n</blockquote>\n\n<p>Sometimes you need to preserve indentation, too.  In those cases, you can create a block code element by starting every line of your code with four spaces (followed by other spaces that will be preserved).  You can get results like the following:</p>\n\n<pre><code>public void main(Strings argv[]){\n    System.out.println(&quot;Hello world!&quot;);\n}\n</code></pre>\n\n<hr/>\n\n<h1>LINKS</h1>\n\n<p>There are a couple of ways to get HTML links.  The easiest is to just paste a valid URL, which will be automatically parsed as a link.  Like so:</p>\n\n<blockquote>\n<p><a href=\"http://en.wikipedia.org\">http://en.wikipedia.org</a></p>\n</blockquote>\n\n<p>However, usually you&#39;ll want to have text that functions as a link.  In that case, include the text inside of square brackets followed by the URL in parentheses. So:</p>\n\n<blockquote>\n<p>[Wikipedia](<a href=\"http://en.wikipedia.org\">http://en.wikipedia.org</a>).</p>\n</blockquote>\n\n<p>results in:</p>\n\n<blockquote>\n<p><a href=\"http://en.wikipedia.org\">Wikipedia</a>.</p>\n</blockquote>\n\n<p>You can also provide tooltip text for links like so:</p>\n\n<blockquote>\n<p>[Wikipedia](<a href=\"http://en.wikipedia.org\">http://en.wikipedia.org</a> &quot;tooltip text&quot;).</p>\n</blockquote>\n\n<p>results in:</p>\n\n<blockquote>\n<p><a href=\"http://en.wikipedia.org\" title=\"tooltip text\">Wikipedia</a>.</p>\n</blockquote>\n\n<p>There are other methods of generating links that aren&#39;t appropriate for discussion-board style comments.  See the <a href=\"http://daringfireball.net/projects/markdown/syntax#link\">Markdown Syntax</a> if you&#39;re interested in more info.</p>\n\n<hr/>\n\n<h1>BLOCK QUOTES</h1>\n\n<p>You&#39;ll probably do a lot of quoting of other redditors.  In those cases, you&#39;ll want to use block quotes.  Simple begin each line you want quoted with a right angle bracket (&gt;).  Multiple angle brackets can be used for nested quotes.  To cause a new paragraph to be quoted, begin that paragraph with another angle bracket.  So the following:</p>\n\n<pre><code>&gt;Here&#39;s a quote.\n\n&gt;Another paragraph in the same quote.\n&gt;&gt;A nested quote.\n\n&gt;Back to a single quote.\n\nAnd finally some unquoted text.\n</code></pre>\n\n<p>Is displayed as:</p>\n\n<blockquote>\n<p>Here&#39;s a quote.</p>\n\n<p>Another paragraph in the same quote.</p>\n\n<blockquote>\n<p>A nested quote.</p>\n</blockquote>\n\n<p>Back to a single quote.</p>\n</blockquote>\n\n<p>And finally some unquoted text.</p>\n\n<hr/>\n\n<h1>MISCELLANEOUS</h1>\n\n<h3>Tables</h3>\n\n<p>Reddit has the ability to represent tabular data in fancy-looking tables.  For example:</p>\n\n<table><thead>\n<tr>\n<th align=\"left\">some</th>\n<th align=\"center\">header</th>\n<th align=\"right\">labels</th>\n</tr>\n</thead><tbody>\n<tr>\n<td align=\"left\">Left-justified</td>\n<td align=\"center\">center-justified</td>\n<td align=\"right\">right-justified</td>\n</tr>\n<tr>\n<td align=\"left\">a</td>\n<td align=\"center\">b</td>\n<td align=\"right\">c</td>\n</tr>\n<tr>\n<td align=\"left\">d</td>\n<td align=\"center\">e</td>\n<td align=\"right\">f</td>\n</tr>\n</tbody></table>\n\n<p>Which is produced with the following markdown:</p>\n\n<blockquote>\n<p><code>some|header|labels</code><br/>\n<code>:---|:--:|---:</code><br/>\n<code>Left-justified|center-justified|right-justified</code><br/>\n<code>a|b|c</code><br/>\n<code>d|e|f</code></p>\n</blockquote>\n\n<p>All you need to produce a table is a row of headers separated by &quot;pipes&quot; (<strong>|</strong>), a row indicating how to justify the columns, and 1 or more rows of data (again, pipe-separated).</p>\n\n<p>The only real &quot;magic&quot; is in the row between the headers and the data.  It should ideally be formed with rows dashes separated by pipes.  If you add a colon to the left of the dashes for a column, that column will be left-justified.  To the right for right justification, and on both sides for centered data.  If there&#39;s no colon, it defaults to left-justified.</p>\n\n<p>Any number of dashes will do, even just one.  You can use none at all if you want it to default to left-justified, but it&#39;s just easier to see what you&#39;re doing if you put a few in there.</p>\n\n<p>Also note that the pipes (signifying the dividing line between cells) don&#39;t have to line up.  You just need the same number of them in every row.</p>\n\n<h3>Escaping special characters</h3>\n\n<p>If you need to display any of the special characters, you can escape that character with a backslash (\\).  For example:</p>\n\n<blockquote>\n<p>Escaped \\*italics\\*</p>\n</blockquote>\n\n<p>results in:</p>\n\n<blockquote>\n<p>Escaped *italics*</p>\n</blockquote>\n\n<h3>Horizontal rules</h3>\n\n<p>Finally, to create a horizontal rule, create a separate paragraph with 5 or more asterisks (*).</p>\n\n<blockquote>\n<p>*****</p>\n</blockquote>\n\n<p>results in</p>\n\n<blockquote>\n<hr/>\n</blockquote>\n</div>";


@end
