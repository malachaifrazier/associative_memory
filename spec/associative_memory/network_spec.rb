require 'spec_helper'

describe AssociativeMemory::Network do
	let(:training_data) {[
		{:input => [1, 0, 1, 0, 1, 0], :output => [1, 1, 0, 0], :converged_output => [5, 7, -5, -7], :converged_input => [4, -4, 4, -4, 4, -4] },
		{:input => [1, 1, 1, 0, 0, 0], :output => [0, 1, 1, 0], :converged_output => [-1, 5, 1, -5], :converged_input => [2, 2, 2, -2, -2, -2] },
		{:input => [0, 1, 0, 1, 0, 1], :output => [0, 0, 1, 1], :converged_output => [-5, -7, 5, 7], :converged_input => [-4, 4, -4, 4, -4, 4] }
	]}
	describe "a new associative memory network" do
		before do
			@network = AssociativeMemory::Network.new
		end
		it "should be a kind of associative memory network" do
			@network.should be_a_kind_of(AssociativeMemory::Network)
		end
		it "should be empty" do
			@network.empty?.should be_true
		end
		it "should not be valid until we learn a pattern" do
			@network.valid?.should be_false
		end
		it "should be valid once we learn a pattern" do
			@network.learn(training_data[0][:input], training_data[0][:output])
			@network.valid?.should be_true
		end
	end

	describe "training a network" do
		before do
			@network = AssociativeMemory::Network.new
		end
		it "should build a valid convergence matrix from a single data point" do
			@network.learn(training_data[0][:input], training_data[0][:output])
			@network.matrix.should == [[1, 1, -1, -1], [-1, -1, 1, 1], [1, 1, -1, -1], [-1, -1, 1, 1], [1, 1, -1, -1], [-1, -1, 1, 1]]
		end
		it "should build a valid convergence matrix from all data" do
			training_data.each do |pair|
				@network.learn(pair[:input], pair[:output])
			end
			@network.matrix.should == [[1, 3, -1, -3], [-3, -1, 3, 1], [1, 3, -1, -3], [-1, -3, 1, 3], [3, 1, -3, -1], [-1, -3, 1, 3]]
		end
	end

	describe "converging a network" do
		before do
			@network = AssociativeMemory::Network.new
			training_data.each do |pair|
				@network.learn(pair[:input], pair[:output])
			end
		end
		it "should rebuild all available output data from learned input data" do
			training_data.each do |pair|
				@network.converge_input(pair[:input]).should == pair[:converged_output]
				@network.converge_and_bitmask_input(pair[:input]).should == pair[:output]
			end
		end
		it "should rebuild all available input data from learned output data" do
			training_data.each do |pair|
				@network.converge_output(pair[:output]).should == pair[:converged_input]
				@network.converge_and_bitmask_output(pair[:output]).should == pair[:input]
			end
		end
	end
end
