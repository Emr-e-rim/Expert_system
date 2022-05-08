/*
  TODO: genderchange
  DONE: genderneutral, singleparent, 3+parents, same-sex marriage, grandchildren,
        https://stackoverflow.com/questions/37871775/prolog-replace-fact-using-fact

  TODO: Does the system use forward or backward chaining.
  DONE: backward chaining

    http://www.lispworks.com/documentation/lw70/KW-W/html/kwprolog-w-18.htm
    inference engine

  TODO: Research where in the "Real world" inference engine is used.
  DONE: BOEING
  https://www.drdobbs.com/parallel/the-practical-application-of-prolog/184405220
*/

/* Facts */

/* Dynamic facts can be changed when using the program */
:-dynamic(male/1).
:-dynamic(female/1).
:-dynamic(neutral/1).
:-dynamic(parent_of/2).

/* Set the names per gender */
male(gijs).
male(jan).
male(sjoerd).
male(nick).
male(john).
male(daan).
male(henk).

female(lieke).
female(sophie).
female(karlijn).
female(marjolein).
female(tess).
female(josefien).
female(julia).
female(linda).

neutral(truus).
neutral(tom).

/* Set the parents */
/* Family 1 */
parent_of(jan, gijs).
parent_of(lieke, gijs).
parent_of(jan, marjolein).
parent_of(lieke, marjolein).
parent_of(jan, tess).
parent_of(lieke, tess).

/* Family 2 */
parent_of(josefien, julia).

/* Family 3 */
parent_of(john, nick).
parent_of(sophie, nick).
parent_of(john, daan).
parent_of(sophie, daan).
parent_of(henk, nick).
parent_of(henk, daan).

/* Family 4 */
parent_of(truus,tom).
parent_of(linda,tom).

/* Family 5: grandparents */
parent_of(sjoerd, lieke).
parent_of(karlijn, lieke).
parent_of(sjoerd, josefien).
parent_of(karlijn,josefien).
parent_of(sjoerd, john).
parent_of(karlijn, john).
parent_of(sjoerd, truus).
parent_of(karlijn, truus).

/* Rules */
/* Rules with true or false answers */

/* Father first */
father_of(X,Y):- male(X),
    parent_of(X,Y).

/* Mother first */
mother_of(X,Y):- female(X),
    parent_of(X,Y).

/* Grandparents: parent of the parent*/
/* Grandfather first */
grandfather_of(X,Y):- male(X),
    parent_of(X,Z),
    parent_of(Z,Y).

/* Grandmother first */
grandmother_of(X,Y):- female(X),
    parent_of(X,Z),
    parent_of(Z,Y).

/* Siblings: father and mother are both true, input cannot be the same*/
/* Sister first */
sister_of(X,Y):- female(X),
    mother_of(M, Y), mother_of(M,X), X \= Y.

sister_of(X,Y):- female(X),
    father_of(F, Y), father_of(F,X), X \= Y.

/* Brother first */
brother_of(X,Y):- male(X),
    mother_of(M, Y), mother_of(M,X), X \= Y.

brother_of(X,Y):- male(X),
    father_of(F, Y), father_of(F,X), X \= Y.

/* Order doesn't matter */
sibling_of(X,Y):-
    father_of(F, Y), father_of(F,X), X \= Y.

sibling_of(X,Y):-
    mother_of(M, Y), mother_of(M,X), X \= Y.

/* Uncle/aunt: sibling of parent */
/* Aunt first */
aunt_of(X,Y):- female(X),
    parent_of(Z,Y), sister_of(X,Z).

/* Uncle first */
uncle_of(X,Y):- male(X),
    parent_of(Z,Y), brother_of(X,Z).

/* Rules with list answers*/
/* setof receives every possible answer en stores the unique ones in X0, the write predicate shows X0.
    The used rules remain the same*/
parents_of(Y):- setof(X,parent_of(X,Y),X0),write(X0).

fathers_of(Y):- setof(X,father_of(X,Y),X0),write(X0).

mothers_of(Y):- setof(X,mother_of(X,Y),X0),write(X0).

grandfathers_of(Y):- setof(X,grandfather_of(X,Y),X0),write(X0).

grandmothers_of(Y):- setof(X,grandmother_of(X,Y),X0),write(X0).

children_of(X):- setof(Y,parent_of(X,Y), X0),write(X0).

grandchildren_of(X):- setof(Y,
    (male(X) -> grandfather_of(X,Y); grandmother_of(X,Y)), X0),write(X0).

siblings_of(Y):- setof(X,sibling_of(X,Y),X0),write(X0).

sisters_of(Y):- setof(X,sister_of(X,Y),X0),write(X0).

aunts_of(Y):- setof(X,aunt_of(X,Y),X0),write(X0).

brothers_of(Y):- setof(X,brother_of(X,Y), X0),write(X0).

uncles_of(Y):- setof(X,uncle_of(X,Y),X0),write(X0).

/*Rules that change facts*/
/* call/1: calls the term to change 
    retract/1: removes the term
    assertz/1: defines the term */
change_gender(OldGender, NewGender):-   % example: change_gender(male(daan), female(daan)). 
    (   call(OldGender)
    ->  retract(OldGender),
        assertz(NewGender)
    ;   true
    ).

no_relationship(ParentChild):-                % example: no_relationship(parent_of(sjoerd,lieke)).
    (   call(ParentChild)
    ->  retract(ParentChild)
    ).

new_relationship(ParentChild):-               % example: new_relationship(parent_of(sjoerd,lieke)).
    assertz(ParentChild).

new_member(Member):-                    % example: new_member(female(liesbeth)).
    assertz(Member).