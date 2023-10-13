#### nnue gauntlet

Tools for testing nnue trained with 
[nnue-pytorch](https://github.com/official-stockfish/nnue-pytorch).
Uses server-worker Docker containers for measuring elo. The more worker
cores added to the worker pool, the faster the results.

This was a fun way to quickly start elo measurements on a pool of nets
at various time controls. In practice, you're better off
testing nets with https://tests.stockfishchess.org/tests
