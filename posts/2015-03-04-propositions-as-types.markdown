---
title: Propositions as types
url: /propositions-as-types.html
---

In Type Theory, **propositions as types** is the idea that types can be interpreted as propositions and vice versa. It is also known as the **Curry-Howard isomorphism** and closely related with the concept of proofs as programs, this is the reason we will use 3 languages during this post: the language of logic, of type theory and Haskell.

<!--more-->

For a basic introduction on type theory, you can read *Per Martin-Löf, Intuitionistic Type Theory*, or the first chapter of *Homotopy Type Theory*.

So let's make the similarities explicit. 

|     logic                           |type theory               |     Haskell      |
|:-----------------------------------:|:------------------------:|:----------------:|
|  \\(p\\\)                           |   \\(A\\)                |        `a`         |
| \\(p\\wedge q\\)                    |  \\(A \\times B\\)       |       `(a,b)`      |
| \\( p \\vee q\\)                    |  \\(A+B\\)               |    `Either a b`    |
|  \\( p\\Rightarrow q\\)             |  \\( A \\to B\\)         |      `a -> b`      |
| \\(\\forall x \ P(x) \\)        |  \\(\\prod_{a:A} P(a)\\)    |                  |
| \\(\\exists x\ P(x) \\)        |  \\(\\sum_{a:A} P(a)\\)    |                  |


And the row that conveys the meaning to it all:


|     logic                           |type theory               |     Haskell      |
|:-----------------------------------:|:------------------------:|:----------------:|
|     proof                 |  inhabitant | program |



Let's do an example. Suppose we want to prove the proposition \\( p \\Rightarrow (q \\Rightarrow p)\\). Under this interpretation, it suffices to give a Haskell function of signature `a -> (b -> a)` (which is the same as `a -> b -> a` because `->` is right associative).

You can think a little bit about it, it is really easy:

```haskell
proof :: a -> b -> a
proof = \a -> \b -> a
```

Note that the language of type theory and Haskell are very similar. (Haskell isn't really as powerful as ML type theory, that's why there are blank spaces on the first table).

Now, you should have noticed that there is something missing on the first table: negation. So let's introduce it. 


|     logic                           |type theory               |     Haskell      |
|:-----------------------------------:|:------------------------:|:----------------:|
|     \\(\\neg A \\)                 |  \\(A \\to 0\\) | `a -> Void` |

This arises some questions. First, what is \\(0\\)? Then, why is that defined like that? And lastly, how is `Void` defined in Haskell?

The first question is easily answered, \\(0\\) is the type that has no constructors. So there is no way to make up an inhabitant of \\(0\\). Now, why is negation defined like that? Simply because it makes sense. Lastly, how is the Void type defined in haskell? Well, it is the type with no constructors, so
```haskell
data Void
```
As simple as that. 

Let's do now another example. We want to prove \\( p \\Rightarrow \\neg \\neg p \\). So it suffices to find a haskell function of signature ```a -> ((a -> Void) -> Void)```. Remember that  ```->``` is right-associative, so that is the same as ```a -> (a -> Void) -> Void```. Here is a solution,
```haskell
proof :: a -> (a -> Void) -> Void
proof = \a -> \f -> f a
```
Note that in the same fashion we can prove ```a -> (a -> b) -> b```. In the language of type theory, that proof would be:
\\[ \\lambda a : A . \\lambda f : A \\to B .f(b) \\ \\ :\\ \\  A \\to ((A \\to B) \\to B) \\]

Now let's try to prove the Law of Excluded Middle (LEM henceforth), i.e. \\(p \\vee \\neg p\\). In the language of type thoery, we have to give an inhabitant of \\(A + (A \\to 0)), but this is impossible in general. If you want to get convinced of that, try to give an element of type ```Either a (a -> Void)``` in Haskell. It is impossible, becuase it would be something like ```Left x``` where ```x :: a``` or ```Right y``` where ```y :: a -> Void```. 

This gives you some intuition on why Type Theory is not isomorphic with classical logic, but rather intuitionistic, or **constructive logic**. For a detailed proof you can see [1]. But this actually makes sense, because semantics of classical propositional formulas are defined in terms of truth values (true and false), and semantics of intuitionistic formulas (can be) defined in terms of provability. 


Proof assistants
----------------

This is the concept on which proof assistants like [Coq](https://coq.inria.fr/) or [Agda](http://wiki.portal.chalmers.se/agda/pmwiki.php) are based on. 
They have fancier type systems than Haskell, but the principles are the same. They implement dependent type theories with inductive types, and that is strong enough to do what they are designed for. [2]

So basically we have to start defining types and proving things about them. To prove a proposition about all elements of a type we often use the induction principle of the type. For example, we can define the naturals as

\\[ 0 : \\mathbb{N} \\]
\\[ s : \\mathbb{N} \\to \\mathbb{N} \\]
\\[ ind_{\\mathbb{N}}(P) : P(0) \\to (\\prod_{n : \\mathbb{N}} P(n) \\to P(s(n))) \to \\prod_{n : \\mathbb{N}} P(n)\\]

This is literally the induction on the naturals. Prove the base case, then prove that vor every natural \\(P(n)\\) implies \\(P(n+1)\\) and then you are done. For more on induction, refer to [3].


Homotopy Type Theory
--------------------

Until now, we have talked about intuitionistic type theory, developed by Per Martin-Löf, but this applies more or less to all type theories (like simply typed lambda calculus or calculus of constructions).
But it is worth to mention the case of HoTT. HoTT is an intensional type theory [(i.e. makes a difference between definitional equality and the equality type, thus admitting a higher-dimensional interpretation of the latter).] [3]

In HoTT not all types can be interpreted as propositions. This is due to the higher-dimensional interpretation we talked about, as types can contan more information than mere provability. So we would like to restrict types that we can interpret as propositions.
This is the definition:

\\[isProp(P) :\\equiv \\prod_{x,y:P} (x=y)\\]

What does it mean? It means that \\(P\\) is a proposition if given two proofs of \\(P\\), \\(x, y\\) then they are equal. This means we *don't care* about proofs being higher-dimensionally different, they are just proofs.

As you can imagine, sometimes given an arbitrary type \\(A\\) we would like to work with it as if it was a mere proposition. We can actually do this, defining an operation \\(||-||\\) such that \\(||A||\\) is a mere proposition for every type \\(A\\). This is explained in detail in the section 3.7. of the book.

Haskell
-------
Haskell not only lacks dependent types, it has another problem when one tries to do this kind of stuff. 
Haskell cannot avoid non-terminating programs, so \\(\\bot\\) (bottom) inhabits every type. One can argue this is a feature rather than a bug (and it is), but take a look at this:

```haskell
data Void                  -- has no constructors, thus no inhabitants, right?

fix :: (a -> a) -> a       -- defined in Data.Function
fix f = let x = f x in x   -- it is the least fixed point of f,
                           -- i.e., the least defined x such that f x = x

false :: Void
false = fix (id :: Void -> Void)
```

And it compiles. So we proved falsity. How? This happens because `fix id` will always hang, it is a nonterminating function, so for every type we have a

```haskell
inhabitant :: a
inhabitant = fix id
```

References
----------

\[1\] Sørenson, Morten; Urzyczyn, Paweł, *Lectures on the Curry-Howard Isomorphism*. Chapter 4

\[2\] [Calculus of Indutive Constructions](https://coq.inria.fr/refman/Reference-Manual006.html)

\[3\] *Homotopy Type Theory*. Chapter 1
