---
title: Binary Codes
url: /binary-codes.html
---

We all know we can write any number in base 2. For example, \\(18_{10} = 10010_2\\). So we can ask a question, are there other (nontrivial) sequences such that any natural number is the sum of a finite subset of it? The answer is yes.

<!--more-->

**Definition.** A strictly increasing sequence \\(a_n \\in \\mathbb{N}^{\\mathbb{N}}\\) is a binary code if for all \\(n \\in \\mathbb{N}\\), there exists a finite subset  \\(A \\subset a_n\\) such that \\(sum(A) = n\\)

**Definition.** \\(n\\) is written in normal form in a given binary code if the maximum of \\(A \\subset \\{a_k\\}\\) is also the largest \\(a_k\\) such that \\(a_k \\leq n < a_{k+1}\\). \\(a_k\\) is a normal binary code if we can write every  \\(n\\) in normal form.

Let's first prove that \\(a_k = 2^k\\) is a binary code.

**Proof.** We will use induction.The base case is trivial.
For the inductive step, given \\(n\\) we suppose that for all \\(n' < n\\) there is a subset \\(A' \\subset \\{2^k\\}_k \\)  such that \\(n' = sum(A')\\); and we want to show that there is a subset  \\(A \\subset \\{2^k\\}_k \\) such that \\(n = sum(A)\\).

We choose the largest \\(k\\) such that \\(2^k \\leq n\\). By the inductive hypothesis, there is a subset \\(A'\\) such that \\(n - 2^k = sum(A')\\), because \\(n - 2^k < n\\). So then we choose \\(A = A' \\sqcup \\{2^k\\}\\) and we are done.

But not so fast, what if \\(n - 2^k \\geq 2^k\\)? If that happens, \\(2^k \\in A'\\), and we don't want that to happen, because that means we need 2 \\(2^k\\) to write the number, and we can only use 0 or 1 of each. So let's prove that can't happen.     

Suppose that  \\(n - 2^k \\geq 2^k\\). Then  \\(n \\geq 2^k + 2^k = 2^{k+1} \\). But that is impossible, because k was largest natural that had thet property, and \\(k+1>k\\).

\\(\\blacksquare\\)

What did we use about \\(a_k = 2^k\\)? We used that
\\[\\forall n \\exists k \\ \\ : \\ a_k \\leq n < a_{k+1}  \\land n-a_k < a_k \\]
Or equivalently

\\[\\forall n \\exists k \\ \\ : \\ a_k \\leq n < a_{k+1}  \\land n < 2a_k \\]


In consequence, if we find a sequence \\(a_k\\) that fulfills this requirement, we know that \\(a_k\\) is a binary code, and the proof is the same that the one of \\(a_k = 2^k\\). 

Examples
--------

Now that we proved it, finding (and proving) some binary codes is easier. (Be aware that we proved an implication, not an equivalence).

We can show that the trivial code \\(a_k = k\\) is a binary code.

**Proof.** Given \\(n\\), we choose \\(k = n\\), so \\(n \\leq n < n+1 \\land n < 2n\\). \\(\\blacksquare\\)


We can also try to show that \\(a_k = F_{k+2}\\), where \\(F_k\\) is the Fibonacci sequence, is a binary code.


**Proof.** Given \\(n\\), we choose \\(k\\) to be the largest \\(k\\) such that \\(a_k \\leq n\\). Then it follows \\(n < a_{k+1}\\). But then \\(n < a_{k+1} = F_{k+3} < 2 F_{k+2} = 2a_{k} \\). \\(\\blacksquare\\)


Note that if \\(\\forall k \ : \ a_{k+1} \\leq 2a_k\\) and \\(a_0 = 1\\) then \\(a_k\\) is a binary code.

**Corollary.** \\(a_1 = 1, a_n = p_n\\) where \\(p_n\\) is the nth prime number is a binary code (Bertrand's postulate).

Bounds and Optimality
--------------------

In this section we will bound the growth of sequences that are binary codes.

The lower bound is obvious. \\(a_k = k\\) is a binary code and any sequence that grows  slower is not strictly increasing.

You can surely suspect the upper bound is \\(a_k = 2^k\\), and it is.    
**Proof.** \\(a_0\\) must always be \\(1\\), otherwise there is no way to represent that number. The same goes with \\(a_1 = 2\\). But for \\(a_2\\) we can choose.
As we are looking for the fastest growing \\(a_k\\) possible, we will choose \\(a_2 = 4\\). Now we can represent all numbers up to \\(7\\).
Then we do the same for the next, so \\(a_3 = 8\\).    
In general, 
\\[a_{k+1} = \\sum_{i=0}^k a_i + 1\\]

And the solution for that is \\(a_k = 2^k\\).
\\(\\blacksquare\\)

Now, let's take the number \\(18\\) as an example, and write it in a couple of codes (in normal form).

* base 2 \\(\\leadsto\\) 10010
* fibonacci \\(\\leadsto\\) 101000
* prime \\(\\leadsto\\) 10000001
* trivial \\(\\leadsto\\) 100000000000000000

So we can ask, in general, what what binary code is optimal, i.e. requires less characters to write in normal form. The math is easy, if we want to write \\(n\\) in normal form it will require \\(k+1\\) characters, where \\(a_k \\leq n < a_{k+1}\\).
  So let \\(f\\) be some extension of \\(a\\) to the reals. Then the number of characters required to write n with \\(a_k\\) in normal form is \\(\\lceil f^{-1}(n)\\rceil\\). Based on what we said before, we can conclude that at best (using base 2) we will have to use \\(\\lceil\\log_2(n)\\rceil\\) characters to write n.



Equivalence of normal binary codes
----------------------------------

Now we will prove that the following statements are equivalent:

1. \\(a_k\\) is a binary code
2. \\(a_k\\) is a normal binary code


**Proof.**  \\(2. \\Rightarrow 1.\\) trivial.

\\(1. \\Rightarrow 2.\\) 
Given \\(a_k\\) binary code and \\(n\\), we want to show that we can choose a subset \\(A \\subset \\{a_k\\}\\) such that \\(sum(A) = n\\) and \\(a_k \\leq n < a_{k+1} \\Rightarrow a_k \\in A\\).


Take \\(l\\), and suppose with all \\(\\{a_0, ..., a_l\\}\\) we can represent \\(\\{1, ..., m\\}\\) where \\(m = \\sum_{i\\leq l} a_i\\)

Then \\(a_l < a_{l+1} \\leq m+1 \\), so the representable numbers are \\(\\{1, ..., m, m+1, ..., m+a_{l+1}\\}\\). Suppose \\(m < n \\leq m + a_{l+1} \\). (We actually choose \\(l\\) so that it fulfills that requierement).

Now there are two cases, the last \\(a_k\\) before \\(n\\) is \\(a_{l+1}\\) or it is greater than it.

Suppose it is \\(a_{l+1}\\). Then \\(n-a_{l+1} \\leq m\\). So \\(n\\) can be represented with \\(a_{l+1}\\) and some combination of \\(\\{a_0, ..., a_l\\}\\), what we wished to show.


The other case is even easier, lets call \\(a_k\\) the largest term less than \\(n\\). As we said, \\(a_k > a_{l+1}\\), so \\(n-a_k < n - a_{l+1} < m\\) and the proof follows as before.
\\(\\blacksquare\\)



