# Convert Wiki Article to Self-Help Article
![AuthorBadge][badge-author]
![PrivacyTag][badge-privacy-general]

---
## Overview / Description
This tool is able to generate a customer ready document from a markdown file<br>
the content that should not be visible to the customer has to be marked at a heading level with `!EXCLUDE`  
that way, all sub-sections are excluded as well.

## How To
1. Create a markdown file that describes the issue and some steps to resoultion
2. Identify which topics we shall not share with the customer. i.e. links etc. to special internal pages etc.
3. Mark these sections with a `! EXCLUDE` tag at the end
4. Put the article in the `\article\` dir
5. Run the script
6. Grab the cx ready articel from `\out\`

### Sample scenario:
In this example we are showcasing on how to convert an article from a general format in to internal and cx ready information.

**Input file:**
```markdown
# Hello world!

## this is a sample file. 
while this text is visible to the customer

## this is not! !EXCLUDE
even this smaller text is excluded

### also this will not be visible.
logically, this text is also not there.

## however, this text, will be visible again!
Yey - you should be able to reach this point when publishing this article.

## Thank you all! !EXCLUDE
```

**Output file (CX Ready):**
```markdown
# Hello world!

## this is a sample file. 
while this text is visible to the customer

## however, this text, will be visible again!
Yey - you should be able to reach this point when publishing this article.
```

**Output file (Internal):**
```markdown
# Hello world!

## this is a sample file. 
while this text is visible to the customer

## this is not! 
even this smaller text is excluded

### also this will not be visible.
logically, this text is also not there.

## however, this text, will be visible again!
Yey - you should be able to reach this point when publishing this article.

## Thank you all! 
```

## Purpose and usecases
Generating wiki articles and customer self-help articles is a time consuming task. Using this script, we are effectivley reducing the amout of effort put in both wiki articles and customer facing documents. This allows us to be consistent with our articles and at the same time, reducing the time required to write both.

## Support
Please open github issue for any kind of issue or support.

<!-- ===========[PAGE END]=========== --->
<!-- 
====
Badge Assets 
====
-->

<!-- Author Badge -->
[badge-author]: https://img.shields.io/badge/Author-justingrah-brightgreen?style=flat-square&logo=microsoft

<!-- OS Release Tags -->
[badge-osrelease-22h2]: https://img.shields.io/badge/OS%20Release-22H2-brightgreen?style=flat-square&logo=microsoftazure


[badge-osrelease-21h2]: https://img.shields.io/badge/OS%20Release-21H2-yellow?style=flat-square&logo=microsoftazure


[badge-osrelease-21h1]: https://img.shields.io/badge/OS%20Release-21H1-red?style=flat-square&logo=microsoftazure


<!-- Privacy Tags -->
[badge-privacy-general]: https://img.shields.io/badge/Privacy%20Tag-General-brightgreen?style=flat-square

[badge-privacy-nda]: https://img.shields.io/badge/Privacy%20Tag-NDA%20Only-yellow?style=flat-square

[badge-privacy-internal]: https://img.shields.io/badge/Privacy%20Tag-Internal%20Only-red?style=flat-square

<!-- Level Tags -->
[badge-level-100]: https://img.shields.io/badge/Level-100%20Foundational-blue?style=flat-square

[badge-level-200]: https://img.shields.io/badge/Level-200%20Specialist-orange?style=flat-square

[badge-level-300]: https://img.shields.io/badge/Level-300%20Advanced-red?style=flat-square

[badge-level-400]: https://img.shields.io/badge/Level-400%20Expert-lightgrey?style=flat-square