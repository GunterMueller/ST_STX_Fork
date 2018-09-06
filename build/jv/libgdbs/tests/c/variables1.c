#include <stdio.h>

typedef struct _data {
    int i;
    char c[20];
    union {
        struct {
            int a;
            int b;
        } as_i;
        struct {
            float f;
            float g;
        } as_f;
    };
} data;

void set_data_i(data *d, int i) {
    d->i = i;
}

void set_data_f(data *d, float f) {
    d->as_f.f = f;
}


int main(int argc, char **argv) {
    data d = {
        1,
        "Hello World!",
        {
            {
                (int)10,
                (int)20
            }
        }
    };
    set_data_i(&d, 12);
    set_data_f(&d, 0.1);
    set_data_i(&d, 24);
    return d.i;
}
