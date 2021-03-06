
MODULES := src

# look for include files in each of the modules
CFLAGS += $(patsubst %,-I%,$(MODULES)) -Werror -fPIC -Wall -g

# extra libraries if required
LIBS := -lm

# each module will add to this
SRC :=

# include the description for each module
include $(patsubst %,%/module.mk,$(MODULES))

# determine the object files
OBJ :=	$(patsubst %.c,%.o, $(filter %.c,$(SRC))) 

LIBECP = libecp.a

.PHONY: clean

# build library 
$(LIBECP): $(OBJ)
	ar rcs $@ $(OBJ)

clean:
	rm -rf libecp.a $(OBJ) 

# calculate C include dependencies
%.dep: %.c
	gcc -MM -MG -MT $(patsubst %.dep,%.o,$@) $(CFLAGS) $< > $@
# C include dependencies
include $(OBJ:.o=.dep)

# example code
example/ex1: example/ex1.c
	gcc -g -O0 -Isrc/ $< -o $@ libecp.a -lm

all: $(LIBECP) example/ex1