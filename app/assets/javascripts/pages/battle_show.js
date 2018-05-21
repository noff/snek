window.showBattle = function(arena_width) {

    // Init app
    window.app = new Vue({
        el: '#app',
        data: {
            currentRound: 0,
            rounds: window.gon.rounds,
            totalRounds: window.gon.rounds.length,
            nowPlaying: false,
            playInterval: null,
            snek_names: window.gon.snek_names
        },
        methods: {
            renderRound: function () {
                this.resetArena();
                var _this = this;
                var sneks = this.rounds[this.currentRound].sneks;
                var direction_code = '';
                sneks.forEach(function(snek, snek_number){
                    snek.position.forEach(function (position, index) {
                        direction_code = _this.directionClass(index, snek);
                        if(index == 0) {
                            $('#c_' + position.x + '_' + position.y).html('<img src="' + gon.snek_parts[snek_number].head + '" class="' + direction_code + '" title="' + snek.snek_id + '">');
                        } else if (index != (snek.position.length - 1) ) {
                            if( snek.position[index-1].x != snek.position[index+1].x && snek.position[index-1].y != snek.position[index+1].y ) {
                                $('#c_' + position.x + '_' + position.y).html('<img src="' + gon.snek_parts[snek_number].curve + '" class="' + direction_code + '">');
                            } else {
                                $('#c_' + position.x + '_' + position.y).html('<img src="' + gon.snek_parts[snek_number].body + '" class="' + direction_code + '">');
                            }
                        } else {
                            $('#c_' + position.x + '_' + position.y).html('<img src="' + gon.snek_parts[snek_number].tail + '" class="' + direction_code + '">');
                        }
                    });
                });

            },

            nextRound: function(){
                if(this.currentRound < (this.totalRounds - 1) ) {
                    this.currentRound++;
                }
            },

            prevRound: function() {
                if(this.currentRound > 0) {
                    this.currentRound--;
                }
            },

            /**
             * @return String
             */
            getSnekName: function(pos) {
                return snek_names[pos];
            },

            /**
             * Get cell direction CSS class
             */
            directionClass: function(position_index, snek_data) {
                var position = snek_data.position;
                var prev = position[position_index - 1];
                var curr = position[position_index];
                var next = position[position_index + 1];

                // Head
                if(prev == null) {
                    if (next.x === curr.x) {
                        if (next.y > curr.y) {
                            return 'cell-up';
                        } else {
                            return 'cell-down';
                        }
                    } else if (next.y === curr.y) {
                        if (next.x > curr.x) {
                            return 'cell-left';
                        } else {
                            return 'cell-right';
                        }
                    }
                }

                // Tail
                if (next == null) {
                    if (prev.x === curr.x) {
                        if (prev.y > curr.y) {
                            return 'cell-down';
                        } else {
                            return 'cell-up';
                        }
                    } else if (prev.y === curr.y) {
                        if (prev.x > curr.x) {
                            return 'cell-right';
                        } else {
                            return 'cell-left';
                        }
                    }
                }

                // Body
                if( prev && next && curr ) {
                    // Horizontal
                    if( prev.y === next.y ) {
                        return 'cell-left';
                        // Vertical
                    } else if (prev.x === next.x ) {
                        return 'cell-up';
                        // Will be curve
                    } else {

                        // Position ⌝. Don't rotate
                        if (prev.y === curr.y && prev.y < next.y && prev.x < curr.x && curr.x === next.x) {
                            return 'cell-left';
                        }
                        if (next.y === curr.y && next.y < prev.y && next.x < curr.x && curr.x === prev.x) {
                            return 'cell-left';
                        }

                        // Position ⌜.
                        if (prev.y === curr.y && prev.y < next.y && prev.x > curr.x && curr.x === next.x) {
                            return 'cell-down';
                        }
                        if (next.y === curr.y && next.y < prev.y && next.x > curr.x && curr.x === prev.x) {
                            return 'cell-down';
                        }

                        // Position ⌞.
                        if (prev.y === curr.y && prev.y > next.y && prev.x > curr.x && curr.x === next.x) {
                            return 'cell-right';
                        }
                        if (next.y === curr.y && next.y > prev.y && next.x > curr.x && curr.x === prev.x) {
                            return 'cell-right';
                        }

                        // Position ⌟.
                        if (prev.y === curr.y && prev.y > next.y && prev.x < curr.x && curr.x === next.x) {
                            return 'cell-up';
                        }
                        if (next.y === curr.y && next.y > prev.y && next.x < curr.x && curr.x === prev.x) {
                            return 'cell-up';
                        }

                    }

                }

                return '';
            },

            resetArena: function() {
                $('#arena table.arena-container td.empty').empty();
            }

        },

        watch: {
            currentRound: function(value) {
                this.renderRound();
            },

            nowPlaying: function(value) {
                if(value) {
                    _this = this;
                    _this.playInterval = setInterval(function(){
                        if(_this.currentRound < (_this.totalRounds - 1) ) {
                            _this.currentRound++;
                        } else {
                            _this.nowPlaying = false;
                        }
                    }, 100);
                } else {
                    if(_this.playInterval ) {
                        clearInterval(_this.playInterval);
                    }
                }
            }
        }

    });

    // On window resize
    $(document).ready(resizeArena);
    $(window).resize(resizeArena);

    // Resize patterns cells
    function resizeArena() {
        var cell_width = parseInt($('#arena table.arena-container').width() / arena_width);
        $('#arena table.arena-container td').width(cell_width);
        $('#arena table.arena-container td').height(cell_width);
    }

    // Run it
    window.app.renderRound();

};