---
title: Linear Recurrences
url: /linear-recurrences.html
---


A linear recurrence is a linear equation that recursively defines a sequence. An example is the Fibonacci sequence, that is defined as

\\[F_0 = 0\\] 
\\[F_1 = 1\\]
\\[F_n = F_{n-1} + F_{n-2}\\]

<!--more-->

In general, a linear recurrence is a sequence \\(\\{a_n\\}_n\\) given by base cases and equations

\\[a_1 = x_1, a_2 = x_k, ..., a_k = x_k\\]
\\[a_n = b_1 a_{n-1} + ... + b_k a_{n-k}\\]

Notice that if the recurrence uses \\(k\\) previous terms, we need to have exactly \\(k\\) base cases, less won't be enough and more would be redundant (it can even be contradictory).


Enter the Matrix
----------------

Linear algebra gives us a tool to solve all linear recurrences. First, let's examine the Fibonacci case. Consider the matrix

\\[F = \\begin{bmatrix} 0 & 1 \\\\ 1 & 1 \\\\ \\end{bmatrix}\\]

It is very easy to see that 

\\[F^n \\begin{bmatrix} 0 \\\\ 1 \\end{bmatrix} = \\begin{bmatrix} F_n \\\\ F_{n+1} \\end{bmatrix} \\]

Now, we all know there are [several ways of multiplying matrices](https://en.wikipedia.org/wiki/Matrix_multiplication#Algorithms_for_efficient_matrix_multiplication). So throwing some divide & conquer at the problem, we can compute the n'th Fibonacci number in \\(O(log(n)\\), supposing matrix multiplication is constant (as every matrix is of size \\(2 \\times 2\\) we can assume that).

But we can do better than that. What if we could calculate \\(F^n\\) even faster? Well, we can.

Diagonalization
---------------

A matrix is diagonal if it is of the form

\\[\\begin{bmatrix}
a_1     & 0       & \\cdots & 0 \\\\
0       & a_2     & \\cdots & 0 \\\\
\\vdots & \\vdots & \\ddots & \\vdots \\\\
0       & 0       & \\cdots & a_n \\\\  \\end{bmatrix}\\]


Note that if \\(A\\) is diagonal, then 

\\[A^k =  \\begin{bmatrix}
a_1^k     & 0       & \\cdots & 0 \\\\
0       & a_2^k     & \\cdots & 0 \\\\
\\vdots & \\vdots & \\ddots & \\vdots \\\\
0       & 0       & \\cdots & a_n^k \\\\  \\end{bmatrix}\\]


A matrix \\(A\\) is diagonalizable if there exist an invertible matrix \\(P\\) such that \\(PAP^{-1}\\) is diagonal. 

Now, knowing all of this, if we could find a matrix \\(P\\) such that \\(D = P\\begin{bmatrix} 0 & 1 \\\\ 1 & 1 \\\\ \\end{bmatrix} P^{-1}\\) is diagonal, then \\[\\begin{bmatrix} 0 & 1 \\\\ 1 & 1 \\\\ \\end{bmatrix}^k = P^{-1} D^k P \\]

And, as we said before, calculating powers of diagonal matrices is very easy. Doing some math, we can find out that

\\[P = \\begin{bmatrix} \\phi & -\\phi^{-1} \\\\ 1 & 1 \\\\ \\end{bmatrix}\\]
\\[D = \\begin{bmatrix} \\phi & 0 \\\\ 0 & -\\phi^{-1} \\\\ \\end{bmatrix}\\]

do the job, where \\(\\phi = \\frac{1 + \\sqrt{5}}{2}\\). So then we are done, we have two solutions.

If we want to compute the n'th fibonacci number using floating point approximations, we can do it in time \\(O(1)\\), and if we want to do it with integer types, without loss of precision, we can do it in \\(O(log(n))\\), with really low constants.

General Case
------------
You may be asking what happens in general, for every linear recurrence relation, i.e., something like:

\\[a_1 = x_1, a_2 = x_k, ..., a_k = x_k\\]
\\[a_n = b_1 a_{n-1} + ... + b_k a_{n-k}\\]


Well, this is easy staring long enough at what we did previously. Note that


\\[\\begin{bmatrix}
0       & 1       & 0       & \\cdots & 0 \\\\
0       & 0       & 1       & \\ddots & \\vdots \\\\
\\vdots & 0       & \\ddots & 1       & 0 \\\\
0       & \\vdots & \\ddots & \\ddots & 1 \\\\
b_k     & b_{k-1} & \\cdots & b_2     & b_1 \\\\  \\end{bmatrix} \\begin{bmatrix}
a_{n-k}       \\\\
a_{n-k+1} \\\\
\\vdots   \\\\
a_{n-2}   \\\\
a_{n-1}   \\\\  \\end{bmatrix} = \\begin{bmatrix}
a_{n-k+1} \\\\
a_{n-k+2} \\\\
\\vdots   \\\\
a_{n-1}   \\\\
a_{n}     \\\\  \\end{bmatrix}\\]

I will call this matrix the "generating matrix" of the linear recurrence. This matrix can remind you of a [known and studied one](https://en.wikipedia.org/wiki/Companion_matrix).

Now, as before, we diagonalize and solve the problem. But, what if the matrix is not diagonalizable? Well, then we can use Jordan normal form, for which there is a closed formula for powers.

It is interesting to see that a really simple tool of linear algebra helped us solving a family of often-ocurring problems.

Another interesting thing I can talk about, is what happens with eigenspaces. Let \\(C\\) be the generating matrix of some linear recurrence, what happens if \\((a_1, a_2, ..., a_k)\\), the vector formed by the first terms of the sequence, is an eigenvector?

Well, then 

\\[C^m \\begin{bmatrix} a_1 \\\\ a_2 \\\\ \\vdots \\\\ a_k \\\\ \\end{bmatrix} = \\lambda^m  \\begin{bmatrix} a_1 \\\\ a_2 \\\\ \\vdots \\\\ a_k \\\\ \\end{bmatrix} \\]

Where \\(\\lambda\\) is a number. So then we are done. 

This allows us to take it even further, because if the generating matrix is diagonalizable, then we can write the whole space as a direct sum of eigenspaces, so we can decompose our vector of first terms in eigenvectors, do the aforementioned calculation, and then sum up all the results. This is one of the reasons why diagonalizable matrices are great, because every vector of the space is a linear combination of eigenvectors.

Another application of linear recurrences are differential equations. Linear differential equations can be solved using exactly the same method we used to solve linear recurrences. As you can probably imagine, this is very useful in physics, becase several families of problems are solved using linear differential equations, and we have a general method to solve them. 



